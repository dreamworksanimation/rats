# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the FloatToRgbMap

add_rats_test(moonray_map_float_to_rgb
    INPUTS scene.rdla
    CANONICALS scene.exr
)

