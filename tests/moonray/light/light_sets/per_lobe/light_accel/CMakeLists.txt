# Copyright 2026 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies that per-lobe lightsets are applied correctly when
# the light accelerator is enabled.

add_rats_test(
    INPUTS ../common.rdla
           light_accel.rdla

    CANONICALS
        scene.exr
)


