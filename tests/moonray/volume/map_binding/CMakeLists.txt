# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests using a volume as a map binding.

add_rats_test(moonray_volume_map_binding
    INPUTS map_binding.rdla
    CANONICALS scene.exr
)

