# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests spheres with glass/subsurface/opaque materials with
# shadows cast by solid/presence/volume objects with a shadow
# ray epsilon value that truncates the shadows.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

