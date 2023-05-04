# RATS ctest suite
The purpose of the RATS ctest suite is to catch visual regressions early due to changes in the codebase that may be intentional or unintentional.
It works by comparing canonical images rendered with a previous version of the software to images rendered with the current version (your bug/feature branch).

This ctest-based suite is experimental and quite primitive at this time of initial development. CTest provides many features for selecting which
tests to run and provides a high-level of control to the developer.  The options are too numerous to mention here - please refer to the CTest documentation.

In contrast to our RaTS python suite there are no "global" canonical images.  Each developer generates and maintains their own canonicals based on some previous
state of the codebase.  Usually this state will be that of a recent release or the latest state that introduced look changes.

This idea of make-your-own-canonicals has both pros and cons, for example:

Pros:
* any machine class and build variant can be supported, which no global canonical set can accomplish
* the quality/sampling/resolution settings can be decided by each developer

Cons:
* developers must generate and update their own canonicals, which can be time consuming
* no standard machine class or variant, which means tests that barely pass on one machine/variant may fail on others
* canonicals used by automated CI plans must be generated and maintained separately

## Building the test suite
These instructions are temporary and subject to change as we continue to evolve our build system.  Building using `rez-build` is not yet supported, but hopefully can be in the future.

```bash
rez2
rez-env cmake gcc-9
cmake --preset dwa-relwithdebinfo --log-context -DRATS_CANONICAL_PATH=/usr/pic1/jlanz/rats2_canonicals -DRATS_RENDER_RES=2 -DRATS_NUM_THREADS=64
cmake --build --preset dwa-relwithdebinfo -- -j <NUM_CPUS> -O
```

There are currently two configure/build-time CMake cache variables that control behavior of the tests:

|CMake cache variable|default|purpose|
|--------------------|-------|-------|
|RATS_CANONICAL_PATH | ""    |the path to store/fetch canonicals from|
|RATS_RENDER_RES     | 1     |a global control that determines the "-res" argument to the moonray render command.  Be sure to match this with the same value used to generate the canonical images|
|RATS_NUM_THREADS    | 2     |the number of threads used to run each of the tests.  Use this in combination with the `-j` jobs argument to control your cpu resources.  For example, if your machine has 64 cores you may want to set RATS_NUM_THREADS=2 and use `-j 32` when you run the tests|

## Generating canonical images
Canonicals should be generated/updated using a previously known good state of the codebase, eg. a recent release.

example canonical generation command, run from the build directory of a previous codebase:
```
ctest -j 16 -L canonicals --output-on-failure
```

Canonicals for new tests can be generated from the current codebase, since the test is new.  Running a diff on a new test will probably only show if the results are deterministic or not.

## Running the tests
example canonical generation command, run from the build directory of the current codebase:
```
ctest -j 16 -L rats --output-on-failure
```

