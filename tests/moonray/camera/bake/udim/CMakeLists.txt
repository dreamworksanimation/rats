# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test bakes the base line mesh scene, using udim.

add_rats_test(moonray_camera_bake_udim
    INPUTS udim.rdla
    CANONICALS
        scene.exr
)

