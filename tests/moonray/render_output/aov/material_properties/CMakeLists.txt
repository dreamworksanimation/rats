# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput objects to output bsdf lobe attributes as material aovs.

add_rats_test(
    INPUTS ../common.rdla
        scene.rdla
    CANONICALS 
        normal.exr
        normal_closest.exr
        roughness.exr
        radius.exr
        matte.exr
        subsurface_normal.exr
        subsurface_radius.exr
        rt_subsurface_normal.exr
        depth.exr
)

