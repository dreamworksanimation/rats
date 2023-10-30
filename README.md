# RATS ctest suite
The purpose of the Render Acceptance Test Suite (RATS) :rat: is to catch visual regressions caused by changes to the codebase that may be intentional or unintentional
before those changes are deployed into a production environment. It works by comparing canonical images rendered with a previously sanctioned version of the renderer
to images rendered with a developmental version (eg. your bug/feature branch).

RATS is built on the CTest framework which provides many features for controlling how and which tests are run. Please refer to the
[CTest Documentation](https://cmake.org/cmake/help/book/mastering-cmake/chapter/Testing%20With%20CMake%20and%20CTest.html) for more information.

## Stages
RATS testing is performed in a series of stages, as follows:
1. The _canonical_ generation stage is run using a recent sanctioned release of MoonRay (generally the most recent release). The resulting rendered images are referred to as the "canonical" images,
and are copied to a location specified during the configuration step via the RATS_CANONICAL_DIR CMake cache variable.
2. The _render_ stage is run using a pre-release candidate version of MoonRay (ie. your bug or feature branch). The resulting rendered images are generated in the build directory under each test
(ie. the ${CMAKE_CURRENT_BINARY_DIR}).
3. The _image diff_ stage is responsible for comparing the resulting rendered images with the previously rendered canonical images.  The diff tests use OpenImageIO's
[idiff](https://openimageio.readthedocs.io/en/latest/idiff.html) tool during execution. Each test can set the tolerances that are used to perform the comparison.

Each stage is comprised of a set of CTest tests. You don't want to run all of the tests at once -- rather you run only the tests associated with each stage.
The next section describes how this is achieved.

The Pass/Fail criteria for each type of test is as follows:
|Stage                 | Pass Criteria |
|----------------------|--------------------|
| canonical            | images are rendered successfully and copied to the RATS_CANONICAL_DIR |
| render               | images are rendered successfully to the CMAKE_CURRENT_BINARY_DIR |
| diff                 | images are compared using the idiff tool and the return code determines pass/fail |

## Test names and labels
To facilitate running the tests in the stages given above we leverage the [LABELS](https://cmake.org/cmake/help/latest/prop_test/LABELS.html) property of CTest tests as well as a naming convention
for each of the tests. This allows the test runner to utilize the `-L`, `-LE`, `-R` and `-E` `ctest` command-line arguments to control which tests are run.

The `-L` and `-LE` `ctest` command-line arguments allow for selecting which tests are included or excluded by performing regular expression matching against each test's _labels_, whereas
the `-R` and `-E` `ctest` command-line arguments allow for selecting which tests are included or excluded by performing regular expression matching against the test _names_.

### Test labels
Each RATS test is labeled according to the stage it is expected to run in:
* canonical: Tests with the "canonical" label are used to render the canonical images and copy them to the directory specified by the RATS_CANONICAL_DIR CMake cache variable.
* render:    Tests with the "render" label are used to render the tests and output the images to the build directory for that test (CMAKE_CURRENT_BINARY_DIR)
* diff:      Tests with the "diff" label execute the `idiff` tool to compare the previously rendered canonical image versus the current rendered image and optionally compare their headers.

As an example, to run all of the tests for the _canonical_ generation stage to generate and store the canonical images you might use `ctest -L 'canonical' <options>`. Be sure to run these tests using
a previously sanctioned release of MoonRay.

Once the canonical images have been generated and it is time to test the results of images rendered with your local branch build you might use `ctest -L 'render' <options>`. This will execute all of the tests
associated with the _render_ stage and produce the rendered images into the build directory.

Following that, the _diff_ stage tests can be run with `ctest -L 'diff' <options>` to compare the rendered images with the canonical counterparts.

There is an automatic dependency relationship between the "render" and "diff" tests for each image, so you can use `ctest -L 'render|diff' -j 64` to execute both the render and diff tests using multiple
jobs with confidence that the render test will execute before the associated diff tests.

### Test names
The tests are named using a convention of tokens separated by underscores in the form `rats_<execution_mode>_<stage>_<testname>`.

The first token for all tests that are associated with RATS is ***rats_***.

The second token is the MoonRay execution mode, abbreviated to 3 characters and is one of ***sca***|***vec***|***xpu***|***def*** for scalar, vector, xpu, and default execution modes respectively.
The "default" execution mode is dependent on the value of the MOONRAY_DEFAULT_EXEC_MODE CMake cache variable when the openmoonray build is configured. "auto" execution mode is not currently tested.

The third token is the RATS test stage and is one of ***canonical***|***render***|***diff***|***header***, the latter for tests that are part of the diff stage but compare the image headers.

The fourth token is the name of the test, which by convention should match the folder structure where the test is stored within the tests/ directory.

For tests belonging to the _diff_ stage a fifth token is appended corresponding to the image filename being compared with its canonical counterpart, eg. ***_scene.exr***.

### Filtering which tests are run by name and label
This test naming/labeling convention allows for reasonably fine control over running certain groups of tests using the `-R`, `-E`, `-L` and `-LE` command-line arguments that `ctest` accepts.

The regular expression syntax and overlapping behavior is poorly documented, but luckily ctest's `-N` command-line argument will print a list of the tests that match. This is quite handy for
checking that your combination of `-R`, `-E`, `-L` and `-LE` arguments are matching the desired tests.

Here are a few examples of how these can be used together:
```
# list all tests CTest can find
ctest -N

# list only tests that start with "rats_"
ctest -N -R '^rats_'

# run the tests to produce all vector execution mode canonicals
ctest -R '^rats_vec_canonical_'

# run the tests to produce all vector execution mode canonicals (same as above)
ctest -R '^rats_vec_' -L 'canonical'

# render and diff tests that have "moonray_geometry" in the name
ctest -L 'render|diff' -R 'moonray_geometry'

# render and diff all vector and xpu mode tests that have "moonray_geometry" in the name
ctest -E '^rats_sca_|^rats_def_' -L 'render|diff' -R 'moonray_geometry'
```

CTest has several other ways to choose which tests are run, such as by individual test numbers.  See CTest documentation for more info.

## Building the RATS test suite
The RATS tests are always built (at the time of this writing) when you build OpenMoonRay, but there are currently two configure/build-time CMake cache variables that control behavior of the tests:

|CMake cache variable|required|default|purpose|
|--------------------|--------|-------|-------|
|RATS_CANONICAL_DIR  |yes     |""     | the path to store/fetch the canonical images |
|RATS_RENDER_THREADS |no      |\<undefined\>| the number of threads to use during rendering.  This is passed to moonray via the -threads argument if defined, otherwise it will use all available threads |

The RATS_CANONICAL_DIR can be anywhere visible to the system. It can be shared across a studio or left to manage by each individual user. The canonicals could be under version control (ie.git LFS),
or completely unmanaged.

Note that different machine configurations can result in slightly different images (ie. noise patterns) so sharing canonical images can be challenging.  Additionally, different image difference
thresholds may be required by different machine classes. Indeed the default image difference thresholds may not work well in certain environments and may need adjusting. The details
surrounding these issues are not covered here, but this is recognized as a potential challenge for users and area of future work.

There are probably many strategies for choosing the RATS_RENDER_THREADS depending on how many parallel jobs you intend to use when running `ctest` with the `-j N` jobs argument. System resources
such as memory, gpu availability, etc. may also factor into the decision.  For those reasons it is left to the user for experimentation.

The RATS_CANONICAL_DIR and RATS_RENDER_THREADS CMake cache variables can be set on the command-line at configure time, for example:

Example for setting the cache RATS variables building with cmake:

```bash
cmake -S . -B ./build -DRATS_CANONICAL_DIR=/path/to/canonicals -DRATS_RENDER_THREADS=4
```

Example for setting the RATS cache variables building with rez-build:

```bash
rez-build -- -DRATS_CANONICAL_DIR=/path/to/canonicals -DRATS_RENDER_THREADS=4
```

The cache variables can also be set using the `ccmake` or `cmake-gui` CMake configuration tools.

## Running the RATS tests
### Prerequisites
You must run the RATS tests from the build directory, in the root of the variant you wish to test.

For example:

```bash
# (may be different in your environment)
cd build/os-CentOS-7/opt_level-optdebug/refplat-vfx2020.3/gcc-6.3.x.2/amorphous-8/openvdb-8/usd_core-0.20.8.x.2
```

You must also be in an environment where the installed openmoonray variant binaries from your build are in your $PATH.

For example, using rez-env:
```bash
# (may be different in your environment)
export REZ_PACKAGES_PATH=/path/to/openmoonray/install:$REZ_PACKAGES_PATH
rez-env openmoonray os-CentOS-7 opt_level-optdebug refplat-vfx2020.3 gcc-6.3.x.2 amorphous-8 openvdb-8 usd_core-0.20.8.x.2
```

Another example, using a container build:
```bash
# bash
source <openmoonray install dir>/scripts/setup.sh
```

You must also have the cmake executable (version 3.23+) available in your $PATH. You can check your cmake version with `cmake --version`.

### Generating canonical images
Canonicals should be generated using a previously sanctioned build of openmoonray, eg. a recent release, and updated as needed as new releases are adopted.

example commands:
```
# generate all canonicals
ctest -L 'canonical' --output-on-failure
```
```
# generate only vector canonicals
ctest -L 'canonical' -R '_vec_' --output-on-failure
```
```
# generate only vector canonicals for moonray_deep_cornell_box test
ctest -R rats_vec_canonical_moonray_deep_cornell_box --output-on-failure
```

There are likely many strategies for updating and managing canonical images, but this is left as an exercise for the user.

### Running the render tests only
example commands:

```
# run all render tests
ctest -L 'render' --output-on-failure
```

```
# run only scalar render tests
ctest -L 'render' -R 'scalar' --output-on-failure
```

```
# run only scalar render test for moonray_geometry_sphere test
ctest -R rats_sca_render_moonray_geometry_sphere --output-on-failure
```

### Running the diff tests only
example commands:

```
# run all diff tests
ctest -L diff --output-on-failure
```

```
# run only xpu diff tests
ctest -L diff -R xpu --output-on-failure
```

```
# run only xpu diff test for one particular scene
ctest -R '^rats_xpu_diff_moonray_camera_multi'
```

### Running the render and diff tests together
example commands:
```
# render and diff all tests
ctest -L 'render|diff' --output-on-failure
```
```
# render and diff all tests using multiple concurrent jobs
ctest -L "render|diff" --output-on-failure -j 16
```

## The Contents of the RATS test suite
### Assets
The assets/ directory uses [Git Large File Storage](https://git-lfs.com/) (LFS) and contains some simple assets that are used by the tests. There isn't much here at the time of this writing, but
it will likely grow over time.
* models/   : a few simple models in .usdc format
* hdri/     : a few simple HDRI images in .exr format
* textures/ : a few simple textures in .tx format

### Tests
The tests are split into two directories based on the executable used to render the images, and contain the scene files and CMakeLists.txt scripts for building the tests.
* tests/moonray
* tests/hd_render

### The CMake scripts for generating the tests
The RATS test suite is implemented on top of CTest and this directory contains the source.
* cmake/

Tests are created via the `add_rats_test()` function found in the cmake/RatsTest.cmake script. See the script source for details about the available options/arguments.

