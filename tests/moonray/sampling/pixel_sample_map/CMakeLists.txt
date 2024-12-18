# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests scaling the pixel samples per pixel by a grayscale image

add_rats_test(moonray_sampling_pixel_sample_map
    INPUTS pixel_sample_map.rdla
    CANONICALS scene.exr
)

