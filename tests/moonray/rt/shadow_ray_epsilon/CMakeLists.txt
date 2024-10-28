# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests spheres with glass/subsurface/opaque materials with
# shadows cast by solid/presence/volume objects with a shadow
# ray epsilon value that truncates the shadows.

add_rats_test(moonray_rt_shadow_ray_epsilon
    INPUTS shadow_ray_epsilon.rdla
    CANONICALS scene.exr
)

