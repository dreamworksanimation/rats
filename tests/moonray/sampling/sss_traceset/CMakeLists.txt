# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the use of trace sets for subsurface scattering

add_rats_test(BASENAME moonray_sampling_sss_traceset
    INPUTS scene.rdla
    CANONICALS scene.exr
)

