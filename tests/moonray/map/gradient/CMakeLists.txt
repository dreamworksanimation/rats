# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies that all the GradientMap common attributes are working. 

add_rats_test(moonray_map_gradient
    INPUTS gradient.rdla
    CANONICALS scene.exr
)

