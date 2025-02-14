# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Description: Tests the tangent space filter, a tool used with the baking camera to make engine-ready normal maps

add_rats_test(BASENAME moonray_displayfilter_tangentspace
    INPUTS scene.rdla
    CANONICALS
        tangents.exr
)

