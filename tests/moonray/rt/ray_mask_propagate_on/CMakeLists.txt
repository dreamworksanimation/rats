# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests the propagate_visibility_bounce_type = true scene var.
# Internally this is the ray mask.

add_rats_test(moonray_rt_ray_mask_propagate_on
    INPUTS ray_mask_propagate_on.rdla
    CANONICALS scene.exr
)

