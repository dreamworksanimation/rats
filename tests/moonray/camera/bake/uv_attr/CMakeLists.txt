# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test bakes the base line mesh scene.

add_rats_test(BASENAME moonray_camera_bake_uv_attr
    INPUTS uv_attr.rdla
    CANONICALS
        scene.exr
)

