# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies that the color correction attributes of the ImageMap are working.

add_rats_test(BASENAME moonray_map_image_color_correction
    INPUTS scene.rdla
    CANONICALS scene.exr
)

