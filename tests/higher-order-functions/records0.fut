-- Storing a function in a record and applying it.
-- ==
-- input { 3 7 2 } output { 71 }
-- input { 5 9 11 } output { 102 }

let add (x:i32) (y:i32) : i32 = x + y

let main (x : i32) (y : i32) (z : i32) =
  let n = 1
  let t = (\(z:i32) -> n+z, 10)
  let r = { a  = 42
          , f  = add
          , f1 = add n
          , g  = \(z:i32) -> z+z+n
          }
  in t.1 z + t.2 + r.f r.a x + r.f1 y + r.g z
