# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies that all the GradientMap common attributes are working. 

add_rats_test(moonray_map_gradient
    INPUTS scene.rdla
    CANONICALS scene.exr
)

