# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.8.0]

### Added

  * Significant performance changes: there is now a constant extra
    compilation overhead (less than 200ms on most machines).  However,
    the rest of the compiler is 30-40% faster (or more in some cases).

  * A warning when ambiguously typed expressions are assigned a
    default (`i32` or `f64`).

  * In-place updates and record updates are now written with `=`
    instead of `<-`.  The latter is deprecated and will be removed in
    the next major version (#650).

### Removed

### Changed

### Fixed

  * Polymorphic value bindings now work properly with module type
    ascription.

  * The type checker no longer requires types used inside local
    functions to be unambiguous at the point where the local function
    is defined.  They must still be unambiguous by the time the
    top-level function ends.  This is similar to what other ML
    languages do.

  * `futhark-bench` now writes "μs" instead of "us".

  * Type inference for infix operators now works properly.

## [0.7.2]

### Added

  * `futhark-pkg` now supports GitLab.

  * `futhark-test`s `--notty` option now has a `--no-terminal` alias.
    `--notty` is deprecated, but still works.

  * `futhark-test` now supports multiple entry points per test block.

  * Functional record updates: `r with f <- x`.

### Fixed

  * Fix the `-C` option for `futhark-test`.

  * Fixed incorrect type of `reduce_by_index`.

  * Segmented `reduce_by_index` now uses much less memory.

## [0.7.1]

### Added

  * C# backend by Mikkel Storgaard Knudsen (`futhark-cs`/`futhark-csopencl`).

  * `futhark-test` and `futhark-bench` now take a `--runner` option.

  * `futharki` now uses a new interpreter that directly interprets the
    source language, rather than operating on the desugared core
    language.  In practice, this means that the interactive mode is
    better, but that interpretation is also much slower.

  * A `trace` function that is semantically `id`, but makes `futharki`
    print out the value.

  * A `break` function that is semantically `id`, but makes `futharki`
    stop and provide the opportunity to inspect variables in scope.

  * A new SOAC, `reduce_by_index`, for expressing generalised
    reductions (sometimes called histograms).  Designed and
    implemented by Sune Hellfritzsch.

### Removed

  * Most of futlib has been removed.  Use external packages instead:

    * `futlib/colour` => https://github.com/athas/matte

    * `futlib/complex` => https://github.com/diku-dk/complex

    * `futlib/date` => https://github.com/diku-dk/date

    * `futlib/fft` => https://github.com/diku-dk/fft

    * `futlib/linalg` => https://github.com/diku-dk/fft

    * `futlib/merge_sort`, `futlib/radix_sort` => https://github.com/diku-dk/sorts

    * `futlib/random` => https://github.com/diku-dk/cpprandom

    * `futlib/segmented` => https://github.com/diku-dk/segmented

    * `futlib/sobol` => https://github.com/diku-dk/sobol

    * `futlib/vector` => https://github.com/athas/vector

    No replacement: `futlib/mss`, `futlib/lss`.

  * `zip6`/`zip7`/`zip8` and their `unzip` variants have been removed.
    If you build gigantic tuples, you're on your own.

  * The `>>>` operator has been removed.  Use an unsigned integer type
    if you want zero-extended right shifts.

### Changed

  * The `largest`/`smallest` values for numeric modules have been
    renamed `highest`/`lowest`.

### Fixed

  * Many small things.

## [0.6.3]

### Added

  * Added a package manager: `futhark-pkg`.  See also [the
    documentation](http://futhark.readthedocs.io/en/latest/package-management.html).

  * Added `log2` and `log10` functions to `f32` and `f64`.

  * Module type refinement (`with`) now permits refining parametric
    types.

  * Better error message when invalid values are passed to generated
    Python entry points.

  * `futhark-doc` now ignores files whose doc comment is the word
    "ignore".

  * `copy` now works on values of any type, not just arrays.

  * Better type inference for array indexing.

### Fixed

  * Floating-point numbers are now correctly rounded to nearest even
    integer, even in exotic cases (#377).

  * Fixed a nasty bug in the type checking of calls to consuming
    functions (#596).

## [0.6.2]

### Added

  * Bounds checking errors now show the erroneous index and the size
    of the indexed array.  Some other size-related errors also show
    more information, but it will be a while before they are all
    converted (and say something useful - it's not entirely
    straightforward).

  * Opaque types now have significantly more readable names,
    especially if you add manual size annotations to the entry point
    definitions.

  * Backticked infix operators can now be used in operator sections.

### Fixed

  * `f64.e` is no longer pi.

  * Generated C library code will no longer `abort()` on application
    errors (#584).

  * Fix file imports on Windows.

  * `futhark-c` and `futhark-opencl` now generates thread-safe code (#586).

  * Significantly better behaviour in OOM situations.

  * Fixed an unsound interaction between in-place updates and
    parametric polymorphism (#589).

## [0.6.1]

### Added

  * The `real` module type now specifies `tan`.

  * `futharki` now supports entering declarations.

  * `futharki` now supports a `:type` command (or `:t` for short).

  * `futhark-test` and `futhark-benchmark` now support gzipped data
    files.  They must have a `.gz` extension.

  * Generated code now frees memory much earlier, which can help
    reduce the footprint.

  * Compilers now accept a `--safe` flag to make them ignore `unsafe`.

  * Module types may now define *lifted* abstract types, using the
    notation `type ^t`.  These may be instantiated with functional
    types.  A lifted abstract type has all the same restrictions as a
    lifted type parameter.

### Removed

  * The `rearrange` construct has been removed.  Use `transpose` instead.

  * `futhark-mode.el` has been moved to a [separate
    repository](https://github.com/diku-dk/futhark-mode).

  * Removed `|>>` and `<<|`.  Use `>->` and `<-<` instead.

  * The `empty` construct is no longer supported.  Just use empty
    array literals.

### Changed

  * Imports of the basis library must now use an absolute path
    (e.g. `/futlib/fft`, not simply `futlib/fft`).

  * `/futlib/vec2` and `/futlib/vec3` have been replaced by a new
    `/futlib/vector` file.

  * Entry points generated by the C code backend are now prefixed with
    `futhark_entry_` rather than just `futhark_`.

  * `zip` and `unzip` are no longer language constructs, but library
    functions, and work only on two arrays and pairs, respectively.
    Use functions `zipN/unzipN` (for `2<=n<=8`).

### Fixed

  * Better error message on EOF.

  * Fixed handling of `..` in `import` paths.

  * Type errors (and other compiler feedback) will no longer contain
    internal names.

  * `futhark-test` and friends can now cope with infinities and NaNs.
    Such values are printed and read as `f32.nan`, `f32.inf`,
    `-f32.inf`, and similarly for `f32`.  In `futhark-test`, NaNs
    compare equal.

## [0.5.2]

### Added

  * Array index section: `(.[i])` is shorthand for `(\x -> x[i])`.
    Full slice syntax supported. (#559)

  * New `assert` construct. (#464)

  * `futhark-mode.el` now contains a definition for flycheck.

### Fixed

  * The index produced by `futhark-doc` now contains correct links.

  * Windows linebreaks are now fully supported for test files (#558).

## [0.5.1]

### Added

  * Entry points need no longer be syntactically first-order.

  * Added overloaded numeric literals (#532).  This means type
    suffixes are rarely required.

  * Binary and unary operators may now be bound in patterns by
    enclosing them in parenthesis.

  * `futhark-doc` now produces much nicer documentation.  Markdown is
    now supported in documentation comments.

  * `/futlib/functional` now has operators `>->` and `<-<` for
    function composition.  `<<|` are `|>>` are deprecated.

  * `/futlib/segmented` now has a `segmented_reduce`.

  * Scans and reductions can now be horizontally fused.

  * `futhark-bench` now supports multiple entry points, just like
    `futhark-test`.

  * ".." is now supported in `include` paths.

### Removed

  * The `reshape` construct has been removed.  Use the
    `flatten`/`unflatten` functions instead.

  * `concat` and `rotate` no longer support the `@` notation.  Use
    `map` nests instead.

  * Removed `-I`/`--library`.  These never worked with
    `futhark-test`/`futhark-bench` anyway.

### Changed

  * When defining a module type, a module of the same name is no
    longer defined (#538).

  * The `default` keyword is no longer supported.

  * `/futlib/merge_sort` and `/futlib/radix_sort` now define
    functions instead of modules.

### Fixed

  * Better type inference for `rearrange` and `rotate`.

  * `import` path resolution is now much more robust.

## [0.4.1]

### Added

  * Unused-result elimination for reductions; particularly useful when
    computing with dual numbers for automatic differentiation.

  * Record field projection is now possible for variables of (then)
    unknown types.  A function parameter must still have an
    unambiguous (complete) type by the time it finishes checking.

### Fixed

  * Fixed interaction between type ascription and type inference (#529).

  * Fixed duplication when an entry point was also called as a function.

  * Futhark now compiles cleanly with GHC 8.4.1 (this is also the new default).

## [0.4.0]

### Added

   * The constructor for generated PyOpenCL classes now accepts a
     `command_queue` parameter (#480).

   * Transposing small arrays is now much faster when using OpenCL
     backend (#478).

   * Infix operators can now be defined in prefix notation, e.g.:

         let (+) (x: i32) (y: i32) = x - y

     This permits them to have type- and shape parameters.

   * Comparison operators (<=, <, >, >=) are now valid for boolean
     operands.

   * Ordinary functions can be used as infix by enclosing them in
     backticks, as in Haskell.  They are left-associative and have
     lowest priority.

   * Numeric modules now have `largest`/`smallest` values.

   * Numeric modules now have `sum`, `product`, `maximum`, and
     `minimum` functions.

   * Added ``--Werror`` command line option to compilers.

   * Higher-order functions are now supported (#323).

   * Type inference is now supported, although with some limitations
     around records, in-place updates, and `unzip`. (#503)

   * Added a range of higher-order utility functions to the prelude,
     including (among others):

         val (|>) '^a '^b: a ->  (a -> b) -> b

         val (<|) '^a '^b: (a -> b) -> a -> b

         val (|>>) '^a 'b '^c: (a -> b) -> (b -> c) -> a -> c

         val (<<|) '^a 'b '^c: (b -> c) -> (a -> b) a -> c

### Changed

   * `FUTHARK_VERSIONED_CODE` is now `FUTHARK_INCREMENTAL_FLATTENING`.

   * The SOACs `map`, `reduce`, `filter`, `partition`, `scan`,
     `stream_red,` and `stream_map` have been replaced with library
     functions.

   * The futlib/mss and futlib/lss modules have been rewritten to use
     higher-order functions instead of modules.

### Fixed

   * Transpositions in generated OpenCL code no longer crashes on
     large but empty arrays (#483).

   * Booleans can now be compared with relational operators without
     crashing the compiler (#499).

## [0.3.1]

### Added

   * `futhark-bench` now tries to align benchmark results for better
     legibility.

### Fixed

   * `futhark-test`: now handles CRLF linebreaks correctly (#471).

   * A record field can be projected from an array index expression (#473).

   * Futhark will now never automatically pick Apple's CPU device for
     OpenCL, as it is rather broken.  You can still select it
     manually (#475).

   * Fixes to `set_bit` functions in the math module (#476).

## [0.3.0]

### Added

   * A comprehensible error message is now issued when attempting to
     run a Futhark program on an OpenCL that does not support the
     types used by the program.  A common case was trying to use
     double-precision floats on an Intel GPU.

   * Parallelism inside of a branch can now be exploited if the branch
     condition and the size of its results is invariant to all
     enclosing parallel loops.

   * A new OpenCL memory manager can in some cases dramatically
     improve performance for repeated invocations of the same entry
     point.

   * Experimental support for incremental flattening.  Set the
     environment variable `FUTHARK_VERSIONED_CODE` to any value to try
     it out.

   * `futhark-dataset`: Add `-t`/`-type` option.  Useful for
     inspecting data files.

   * Better error message when ranges written with two dots
     (`x..y`).

   * Type errors involving abstract types from modules now use
     qualified names (less "expected 't', got 't'", more "expected
     'foo.t', got 'bar.t'").

   * Shorter compile times for most programs.

   * `futhark-bench`: Add ``--skip-compilation`` flag.

   * `scatter` expressions nested in `map`s are now parallelised.

   * futlib: an `fft` module has been added, thanks to David
     P.H. Jørgensen and Kasper Abildtrup Hansen.

### Removed

   * `futhark-dataset`: Removed `--binary-no-header` and
     `--binary-only-header` options.

   * The `split` language construct has been removed.  There is a
     library function `split` that does approximately the same.

### Changed

  * futlib: the `complex` module now produces a non-abstract `complex`
    type.

  * futlib: the `random` module has been overhauled, with several new
    engines and adaptors changed, and some of the module types
    changed.  In particular, `rng_distribution` now contains a numeric
    module instead of an abstract type.

  * futlib: The `vec2` and `vec3` modules now represent vectors as
    records rather than tuples.

  * futlib: The `linalg` module now has distinct convenience functions
    for multiplying matrices with row and column vectors.

  * Only entry points defined directly in the file given to the
    compiler will be visible.

  * Range literals are now written without brackets: `x...y`.

  * The syntax `(-x)` can no longer be used for a partial application
    of subtraction.

  * `futhark-test` and `futhark-bench` will no longer append `.bin` to
    executables.

  * `futhark-test` and `futhark-bench` now replaces actual/expected
    files from previous runs, rather than increasing the litter.

### Fixed

  * Fusion would sometimes remove safety checks on e.g. `reshape`
    (#436).

  * Variables used as implicit fields in a record construction are now
    properly recognised as being used.

  * futlib: the `num_bits` field for the integer modules in `math` now
    have correct values.

## [0.2.0]

### Added

  * Run-time errors due to failed assertions now include a stack
    trace.

  * Generated OpenCL code now picks more sensible group size and count
    when running on a CPU.

  * `scatter` expressions nested in `map`s may now be parallelised
    ("segmented scatter").

  * Add `num_bits`/`get_bit`/`set_bit` functions to numeric module
    types, including a new `float` module type.

  * Size annotations may now refer to preceding parameters, e.g:

        let f (n: i32) (xs: [n]i32) = ...

  * `futhark-doc`: retain parameter names in generated docs.

  * `futhark-doc`: now takes `-v`/`--verbose` options.

  * `futhark-doc`: now generates valid HTML.

  * `futhark-doc`: now permits files to contain a leading documentation
    comment.

  * `futhark-py`/`futhark-pyopencl`: Better dynamic type checking in
    entry points.

  * Primitive functions (sqrt etc) can now be constant-folded.

  * Futlib: /futlib/vec2 added.

### Removed

  * The built-in `shape` function has been removed.  Use `length` or
    size parameters.

### Changed

  * The `from_i32`/`from_i64` functions of the `numeric` module type
    have been replaced with functions named `i32`/`i64`.  Similarly
    functions have been added for all the other primitive types
    (factored into a new `from_prim` module type).

  * The overloaded type conversion functions (`i32`, `f32`, `bool`,
    etc) have been removed.  Four functions have been introduced for
    the special cases of converting between `f32`/`f64` and `i32`:
    `r32`, `r64`, `t32`, `t64`.

  * Modules and variables now inhabit the same name space.  As a
    consequence, we now use `x.y` to access field `y` of record `x`.

  * Record expression syntax has been simplified.  Record
    concatenation and update is no longer directly supported.
    However, fields can now be implicitly defined: `{x,y}` now creates
    a record with field `x` and `y`, with values taken from the
    variables `x` and `y` in scope.

### Fixed

  * The `!=` operator now works properly on arrays (#426).

  * Allocations were sometimes hoisted incorrectly (#419).

  * `f32.e` is no longer pi.

  * Various other fixes.

## [0.1.0]

  (This is just a list of highlights of what was included in the first
   release.)

  * Code generators: Python and C, both with OpenCL.

  * Higher-order ML-style module system.

  * In-place updates.

  * Tooling: futhark-test, futhark-bench, futhark-dataset, futhark-doc.

  * Beginnings of a basis library, "futlib".
