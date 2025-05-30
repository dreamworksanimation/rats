# RATS CTest suite
The purpose of the Render Acceptance Test Suite (RATS) is to catch visual regressions caused by changes to the codebase that may be intentional or unintentional
before those changes are deployed into a production environment. It works by comparing canonical images rendered with a previously sanctioned version of the renderer
to images rendered with a developmental version (i.e. built from your bug/feature branch).  RATS is built on the [CTest](https://cmake.org/cmake/help/book/mastering-cmake/chapter/Testing%20With%20CMake%20and%20CTest.html) framework.

The test suite comprises several hundred mini-scenes, each designed to test some behavior of the renderer, cameras, materials, maps, lights, etc.

The first step to using the RATS suite is to generate an initial set of canonical images and difference thresholds by running the subset of tests with the 'update' label.
These images should be rendered using a trusted build of MoonRay (a non-development branch).
You must specify a location to store the canonical images via the RATS_CANONICAL_DIR environment variable.
```bash
# generate canonical images and difference thresholds for all tests
export RATS_CANONICAL_DIR=/path/to/my/rats_canonicals
ctest -L update -j $(nproc)
```

Once an initial set of canonical images has been generated the test suite is typically run using a development build and specifying the 'render' and 'diff' labels in the ctest command, for example:
```bash
# Render each scene and compare the results with the canonical images
export RATS_CANONICAL_DIR=/path/to/my/rats_canonicals
ctest -L 'render|diff' -j $(nproc)
```

The examples above are not complete. See the "RATS runtime environment" section below for more information on running the tests.

## RATS runtime environment
You must run the RATS tests from the build directory, after sourcing the moonray runtime environment script (`setup.sh`).
You must also specify the location of the canonical images via the RATS_CANONICAL_DIR environment variable.

For example:
```bash
cd build/openmoonray
source ../installs/openmoonray/scripts/setup.sh
export RATS_CANONICAL_DIR=/path/to/my/rats_canonicals
ctest -L 'render|diff'
```

## Test labels
To facilitate running the tests in subsets we leverage the [LABELS](https://cmake.org/cmake/help/latest/prop_test/LABELS.html) property of CTest tests as well as a naming convention (see below).  
The `-L` and `-LE` `ctest` command-line arguments allow for selecting which tests are included or excluded by performing regular expression matching against each test's _labels_.

The tests in the RATS suite are named and labeled according to their purpose.
1. Tests with the _update_ label are for generating canonical images.  These tests should be run using a non-development build.
1. Tests with the _render_ label are for rendering test images using a development build.
1. Tests with the _diff_ label are for comparing the previously rendered test images with the previously rendered canonical images.
1. Tests with the _header_ label are for comparing the previously rendered test image headers with the previously rendered canonical image headers. For convenience these tests also have the _diff_ label.

The tests with the _render_ and _diff_ labels can be run together, e.g. `ctest -L 'render|diff'`.  An explicit dependency ensures that the _render_ test is executed prior to the associated _diff_ test.

### _update_
The tests with the _update_ label perform the following steps:
- the test scene is rendered 25 times, resulting in 25 sets of candidate images
- each of these images is compared with the other images via per-pixel absolute difference
- the statistics from the comparisons are gathered and analyzed
- one set of images is chosen and copied to the location specified by the RATS_CANONICAL_DIR env variable.
- ideal difference thresholds are chosen and written to an accompanying file called diff.json alongside the new canonical images

These tests should be run once to generate an initial set of canonical images and difference thresholds, and again anytime it is deemed necessary.  For example, updating some or all of the canonical
images may be required when:
- a change is made to any of MoonRay's code that causes an intentional look change (e.g. a bug fix)
- a change is made to any of the test scenes or the assets it uses, for whatever reason
- a change is made to the class of hardware/OS that the test suite runs on

Note that running all of these tests may take several hours, even on a very fast machine. Storing the canonical images requires ~1.4GB at the time of this writing.
It is likely that each class of machine that is intended to run the RATS suite will require its own set of canonical images.

These tests are considered passing if they successfully execute the steps outlined above.

### _render_
The tests with the _render_ label perform the following steps:
- the test scene is rendered once, with the resulting test images written to the build directory for that test.

These tests are considered passing if they successfully render the scene.

### _diff_
The tests with the _diff_ label are meant to be run with or just after the tests with the _render_ label, and perform the following steps:
- the test images are compared with the associated canonical images using OpenImageIO's [idiff](https://openimageio.readthedocs.io/en/latest/idiff.html) tool with the difference thresholds found in the associated diff.json file.

These tests are considered passing if the differences between the test images and the canonical images are within the thresholds specified in the diff.json file.

### _header_
The tests with the _header_ label are meant to be run with or just after the tests with the _render_ label, and perform the following steps:
- the metadata found in the test image headers is compared with that in the associated canonical image headers.

These tests are considered passing if the metadata is considered the same.


## Test names
The tests are named using a convention of tokens separated by hyphens in the form `<stage>-<execution_mode>-<testname>`.
- The first token is the RATS test stage and is one of ***update***|***render***|***diff***|***header***.
- The second token is the MoonRay execution mode, abbreviated to 3 characters and is one of ***sca***|***vec***|***xpu*** for scalar, vector and xpu execution modes.
- The third token is the name of the test, which by convention matches the relative directory structure of the test within the rats/tests/ directory.
- For tests belonging to the _diff_ stage a fourth token is appended corresponding to the image filename being compared with its canonical counterpart, eg. ***-scene.exr***.

## Filtering which tests are run by name and label
This test naming/labeling convention allows for control over running certain groups of tests using the `-R`, `-E`, `-L` and `-LE` command-line arguments that `ctest` accepts.

The regular expression syntax and overlapping behavior is poorly documented, but luckily ctest's `-N` command-line argument will print a list of the tests that match without actually executing the tests.
This is handy for checking that your combination of `-R`, `-E`, `-L` and `-LE` arguments are matching the desired tests.   Multiple -L arguments are supported, and they form an AND behavior for matches.
For example to select the 'update' tests that use xpu or vector execution modes use `-L update -L 'vector|xpu'`, i.e. has the update label AND the vector or xpu label

Here are a few examples of how these can be used together:
```bash
# list all tests CTest can find (including the unit tests which are not part of the RATS suite)
ctest -N

# list all tests that are part of the RATS suite
ctest -N -L rats

# run the render tests for vector execution mode
ctest -L render -L vector

# run the tests that perform the canonical/diff threshold updates for scalar execution mode
ctest -L update -L scalar

# run the render and diff tests that have "moonray/geometry" in the name
ctest -L 'render|diff' -R 'moonray/geometry'

# run the render and diff stages for all vector and xpu mode tests that have "moonray/geometry" in the name
ctest -L 'vector|xpu' -L 'render|diff' -R 'moonray/geometry'
```

CTest has several other ways to choose which tests are run, such as by individual test numbers or by reading a list of tests from a file.  See the CTest documentation for more info.

## The Contents of the RATS test suite
### Assets
The assets/ directory uses [Git Large File Storage](https://git-lfs.com/) (LFS) and contains some simple assets that are used by the tests.
* models/   : a few simple models in .usdc format
* hdri/     : a few simple HDRI images in .exr format
* textures/ : a few simple textures in .tx format

### Tests
The tests are split into two directories based on the executable used to render the images, and contain the scene files and CMakeLists.txt scripts for building the tests.
* tests/moonray
* tests/hd_render (currently only contains a single test)

### The CMake scripts for generating the tests
The RATS test suite is implemented on top of CTest and this directory contains the source.
* cmake/

Tests are created via the `add_rats_test()` function found in the cmake/RatsTest.cmake module. See the script source for details about the available options/arguments.

The remaining scripts in the cmake/ directory are invoked at test run time.

It is possible to use a custom image diff tool in place of the default one. To do this, simply place a CMake script named diff.cmake in your test directory and it will be
called instead of the default `cmake/diff.cmake` script. See cmake/diff.cmake for script inputs.

