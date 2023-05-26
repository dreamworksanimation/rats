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

## Stages
Each test has several stages, as follows:
* canonical generation
* result render
* image diff

## Test names and labels
The tests are named with the convention `rats_<execmode>_<stage>_testname`.

The tests are labeled according to their stage:
* canonical
* render
* diff

## Building the test suite
Building using `rez-build` as usual, and the RaTS tests will be built as well. Arguments passed after the ' -- ' are appended to the cmake build command.

There are currently two configure/build-time CMake cache variables that control behavior of the tests:

|CMake cache variable|default|purpose|
|--------------------|-------|-------|
|RATS_CANONICAL_PATH | ""    |the path to store/fetch canonicals from|
|RATS_RENDER_RES     | 1     |a global control that determines the "-res" argument to the moonray render commands|
|RATS_NUM_THREADS    | 2     |the number of threads used to run each of the tests (see below)|

There are two strategies for setting the RATS_NUM_THREADS:
1) set to a small number (ie. 2) and use the `-j` arg with CTest to specify the number of jobs to run simultaneously.  For example, if your machine has 32 cores you might choose to set
`RATS_NUM_THREADS=2` and pass the `-j 16` argument to the CTest command
2) set to the available number of cores on your machine and use 1 job at a time.  For example, of you machine has 32 cores you might choose to set `RATS_NUM_THREADS=32` and do NOT pass
the `-j` argument to the CTest command.

In practice option 2 seems to run the fastest overall. Using option 1 might cause your system's memory to be a bottleneck.

For example:
```bash
rez2
rez-build -i -p /path/to/install --variants 0 -- --log-context -DRATS_CANONICAL_PATH=/path/to/canonicals -DRATS_NUM_THREADS=16
```

## Running the rats tests
You must run the rats tests from the build directory, in the variant you wish to test.
You'll need to prepred your REZ_PACKAGES_PATH with your openmoonray package install dir.

For example, from the source dir:
```bash
REZ_PACKAGES_PATH=/path/to/install:$REZ_PACKAGES_PATH
rez-env cmake-3.23 openmoonray os-CentOS-7 opt_level-optdebug refplat-vfx2020.3 gcc-6.3.x.2 amorphous-8 openvdb-8 usd_core-0.20.8.x.2
cd build/os-CentOS-7/opt_level-optdebug/refplat-vfx2020.3/gcc-6.3.x.2/amorphous-8/openvdb-8/usd_core-0.20.8.x.2
ctest -L 'render|diff' -j 4
```

### Generating canonical images
Canonicals should be generated/updated using a previously known good state of the codebase, eg. a recent release.

example canonical generation commands:
```
# generate all canonicals
ctest -L canonical --output-on-failure
```
```
# generate only vector canonicals
ctest -L canonical -R vector --output-on-failure
```
```
# generate only vector canonicals for cornell_box test
ctest -R vector_canonical_cornell_box --output-on-failure
```

Canonicals for new tests can be generated from the current codebase, since the test is new.  Running a diff on a new test will probably only show if the results are deterministic or not.

### Running the render tests only

example render commands:
```
# run all render tests
ctest -L render --output-on-failure
```
```
# run only scalar render tests
ctest -L render -R scalar --output-on-failure
```
```
# run only scalar render test for cornell_box test
ctest -R scalar_render_cornell_box --output-on-failure
```

### Running the diff tests only
Assuming the canonicals are generated/updated and current images have already been generated, you can adjust the diff test settings, build, and re-run just the diff tests.

example diff commands:
```
# run all diff tests
ctest -L diff --output-on-failure
```
```
# run only xpu diff tests
ctest -L diff -R xpu --output-on-failure
```

This one can be particularly handy for tweaking diff thresholds and quickly testing the result
```
# run only xpu diff test for cornell_box scene
ctest -L diff -R xpu --output-on-failure
```

### Running the render and diff tests together
The 'rats' label is applied to all render and diff tests.
```
# render and diff all tests
ctest -L "render|diff" --output-on-failure
```
```
# render and diff only xpu tests
ctest -L "render|diff" -R xpu --output-on-failure
```
```
# render and diff only xpu tests for cornell_box scene
ctest -L "render|diff" -R xpu --output-on-failure
```

## Limitations, future work
- [ ] Support multiple RenderOutputs.  Currently only a single output image is handled
- [ ] Support the `hd_render` command for running moonray via the hydra delegate. This would enable us to render .usd scenes
- [ ] Add a new profiling suite using this CTest framework
