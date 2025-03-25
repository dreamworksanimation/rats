# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises unbounded lights; i.e. the following light types
#
#   DistantLight
#   EnvLight
#
# The DistantLight is the yellow sun reflected in the widget. This light type only supports a non-textured version.
# EnvLight is tested in both texture and non-textured versions - the textured one shows the sky and mountains, and the
# non-textured one is the green lower hemisphere.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

