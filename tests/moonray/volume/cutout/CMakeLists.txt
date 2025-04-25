# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# A scene with two overlapping volumes in front of a plane.
# One of the volumes is cutout.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

