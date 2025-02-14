# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# A rect light reflected in a mirror with 0.5 presence.
# Tests that reflective objects with presence render correcty.

add_rats_test(BASENAME moonray_rt_presence_mirror
    INPUTS scene.rdla
    CANONICALS scene.exr
)

