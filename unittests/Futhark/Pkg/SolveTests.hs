{-# LANGUAGE OverloadedStrings #-}
module Futhark.Pkg.SolveTests (tests) where

import qualified Data.Map as M
import qualified Data.Text as T
import Data.Monoid

import Test.HUnit hiding (Test)
import Test.Framework
import Test.Framework.Providers.HUnit

import Futhark.Pkg.Types
import Futhark.Pkg.Solve

semverE :: T.Text -> SemVer
semverE s = case semver s of
              Left err -> error $ T.unpack s <>
                          " is not a valid version number: " <>
                          parseErrorPretty err
              Right x -> x

-- | A world of packages and interdependencies for testing the solver
-- without touching the outside world.
testEnv :: PkgRevDepInfo
testEnv = M.fromList $ concatMap frob
  [ ("athas", [ ("foo", [ ("0.1.0", [])
                        , ("0.2.0", [("athas/bar", "1.0.0")])
                        , ("0.3.0", [])])
              , ("foo@v2", [ ("2.0.0", [("athas/quux", "0.1.0")])])
              , ("bar", [ ("1.0.0", [])])
              , ("baz", [ ("0.1.0", [("athas/foo", "0.3.0")])])
              , ("quux", [ ("0.1.0", [ ("athas/foo", "0.2.0")
                                     , ("athas/baz", "0.1.0") ])])
              , ("quux_perm", [ ("0.1.0", [ ("athas/baz", "0.1.0")
                                          , ("athas/foo", "0.2.0")])])
              ])

  -- Some mutually recursive packages.
  , ("nasty", [ ("foo", [ ("1.0.0", [("nasty/bar", "1.0.0")])])
              , ("bar", [ ("1.0.0", [("nasty/foo", "1.0.0")])])])
  ]
  where frob (user, repos) = do
          (repo, repo_revs) <- repos
          (rev, deps) <- repo_revs
          let rev' = semverE rev
              onDep (dp, dv) = (dp, (semverE dv, Nothing))
              deps' = PkgRevDeps $ M.fromList $ map onDep deps
          return ((user <> "/" <> repo, rev'), deps')

solverTest :: PkgPath -> T.Text -> Either T.Text [(PkgPath, T.Text)] -> Test
solverTest p v expected =
  testCase (T.unpack $ p <> "-" <> prettySemVer v') $
  fmap unBuildList (solveDepsPure testEnv target)
  @?= expected'
  where target = PkgRevDeps $ M.singleton p (v', Nothing)
        v' = semverE v
        expected' = M.fromList . map onRes <$> expected
        onRes (dp, dv) = (dp, semverE dv)

tests :: [Test]
tests =
  [
    solverTest "athas/foo" "0.1.0" $
    Right [ ("athas/foo", "0.1.0")]

  , solverTest "athas/foo" "0.2.0" $
    Right [ ("athas/foo", "0.2.0")
          , ("athas/bar", "1.0.0")]

  , solverTest "athas/quux" "0.1.0" $
    Right [ ("athas/quux", "0.1.0")
          , ("athas/foo", "0.3.0")
          , ("athas/baz", "0.1.0")]

  , solverTest "athas/quux_perm" "0.1.0" $
    Right [ ("athas/quux_perm", "0.1.0")
          , ("athas/foo", "0.3.0")
          , ("athas/baz", "0.1.0")]

  , solverTest "athas/foo@v2" "2.0.0" $
    Right [ ("athas/foo@v2", "2.0.0")
          , ("athas/quux", "0.1.0")
          , ("athas/foo", "0.3.0")
          , ("athas/baz", "0.1.0")
          ]

  , solverTest "athas/foo@v3" "3.0.0" $
    Left "Unknown package/version: athas/foo@v3-3.0.0"

  , solverTest "nasty/foo" "1.0.0" $
    Right [ ("nasty/foo", "1.0.0")
          , ("nasty/bar", "1.0.0")]
  ]