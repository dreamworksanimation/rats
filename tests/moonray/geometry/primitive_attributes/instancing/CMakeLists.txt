# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests primitive attribute behavior with multi-level instancing

add_rats_test(BASENAME moonray_geometry_primitive_attributes_instancing
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

