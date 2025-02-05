# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests using a volume as a map binding via instancing.

add_rats_test(moonray_volume_instancing_map_binding
    INPUTS scene.rdla
    CANONICALS scene.exr
)

