# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Test glitter reference parameter
add_rats_test(BASENAME moonray_material_glitter_ref
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

