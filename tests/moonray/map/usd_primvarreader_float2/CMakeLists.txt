# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the UsePrimvarReader_float2 map

add_rats_test(moonray_map_usd_primvarreader_float2
    INPUTS usd_primvarreader_float2.rdla
    CANONICALS scene.exr
)

