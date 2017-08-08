{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ConstraintKinds #-}
-- | Find safety condition 5 for all statements.
module Futhark.Optimise.MemoryBlockMerging.Coalescing.SafetyCondition5
  ( findSafetyCondition5FunDef
  ) where

import qualified Data.Map.Strict as M
import qualified Data.Set as S
import Control.Monad
import Control.Monad.RWS

import Futhark.Representation.AST
import Futhark.Representation.ExplicitMemory (ExplicitMemory)

import Futhark.Optimise.MemoryBlockMerging.Types
import Futhark.Optimise.MemoryBlockMerging.Miscellaneous


type DeclarationsSoFar = Names
type VarsInUseBeforeMem = M.Map VName Names

newtype FindM a = FindM { unFindM :: RWS FirstUses
                          VarsInUseBeforeMem DeclarationsSoFar a }
  deriving (Monad, Functor, Applicative,
            MonadReader FirstUses,
            MonadWriter VarsInUseBeforeMem,
            MonadState DeclarationsSoFar)

findSafetyCondition5FunDef :: FunDef ExplicitMemory -> FirstUses
                           -> VarsInUseBeforeMem
findSafetyCondition5FunDef fundef first_uses =
  let m = unFindM $ do
        forM_ (funDefParams fundef) lookInFParam
        lookInBody $ funDefBody fundef
      res = snd $ evalRWS m first_uses S.empty
  in res

lookInFParam :: FParam ExplicitMemory -> FindM ()
lookInFParam (Param x _) =
  modify $ S.insert x

lookInBody :: Body ExplicitMemory -> FindM ()
lookInBody (Body _ bnds _res) =
  mapM_ lookInStm bnds

lookInStm :: Stm ExplicitMemory -> FindM ()
lookInStm stm@(Let _ _ e) = do
  let new_decls = newDeclarationsStm stm

  first_uses <- ask
  declarations_so_far <- get
  forM_ (S.toList $ S.unions $ map (`lookupEmptyable` first_uses) new_decls) $ \mem ->
    tell $ M.singleton mem declarations_so_far

  forM_ new_decls $ \x ->
    modify $ S.insert x

  -- Special loop handling: Extract useful variables that are in use.
  case e of
    DoLoop _ _ loopform _ ->
      case loopform of
        ForLoop i _ _ _ -> modify $ S.insert i
        WhileLoop c -> modify $ S.insert c
    _ -> return ()

  -- RECURSIVE BODY WALK.
  walkExpM walker e
  where walker = identityWalker
          { walkOnBody = lookInBody
          , walkOnFParam = lookInFParam
          }
