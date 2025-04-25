# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests extending the ramp on DwaToonMaterial, in conjunction with prevent_light_culling

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

