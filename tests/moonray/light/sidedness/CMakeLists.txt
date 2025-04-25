# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises the sidedness property for RectLight, DiskLight, SphereLight and CylinderLight.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

