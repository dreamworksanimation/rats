# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests motion-blur camera shutter settings with deltas

add_rats_test(
    INPUTS ../common.rdla
           scene.rdla
    DELTAS deltas.rdla
    CANONICALS scene.exr
)

