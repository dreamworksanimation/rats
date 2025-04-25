# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests DwaLayer with respect to layering dielectric specular

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

