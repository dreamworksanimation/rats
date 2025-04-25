# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests a beauty render of the Clearcoat Implementation (clearcoat + absorption + thickness)

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

