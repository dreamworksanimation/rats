# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the correctness of the RenderOutput objects output of material aovs pbr validity property for plastic and metals setup.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS result0.exr
)

