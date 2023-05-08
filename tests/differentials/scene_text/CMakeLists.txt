# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(differentials_scene_text
    # DENOISE
    SCENE_DIR ${CMAKE_CURRENT_SOURCE_DIR}
    INPUTS
        scene.rdla
    EXEC_MODES
        scalar
        vector
        xpu
    # MOONRAY_ARGS
        # -scene_var \"pixel_samples\" \"24\" -res 2
    OUTPUTS
        scene.exr
    IDIFF_ARGS
        -fail 0.05            # Failure absolute difference threshold (default: 1e-06)
        # -failrelative 0       # Failure relative threshold (default: 0)
        -failpercent 2        # Allow this percentage of failures (default: 0)
        # -hardfail inf         # Fail if any one pixel exceeds this error (default: inf)
        # -allowfailures 0      # OK for this number of pixels to fail by any amount (default: 0)
        -warn 0.09            # Warning absolute difference threshold (default: 1e-06)
        # -warnrelative 0       # Warning relative threshold (default: 0)
        -warnpercent 2        # Allow this percentage of warnings (default: 0)
        # -hardwarn inf         # Warn if any one pixel exceeds this error (default: inf)
        # -scale 1              # Scale the output image by this factor (default: 1)
        -v                    # Verbose status messages
        -a                    # Compare all subimages/miplevels
        -p                    # Perform perceptual (rather than numeric) comparison
)



