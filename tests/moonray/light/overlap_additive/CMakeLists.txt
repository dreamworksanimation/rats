# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises overlapping lights

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr

    # overlapping lights that are visible to the camera are sampled stochastically,
    # causing non-determism in vector and xpu modes.  This makes it difficult to
    # get this test to pass consistently
    NO_VECTOR  
    NO_XPU
)

