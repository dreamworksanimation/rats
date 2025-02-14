# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests using a volume as a map binding.

add_rats_test(BASENAME moonray_volume_map_binding
    INPUTS scene.rdla
    CANONICALS scene.exr
)

