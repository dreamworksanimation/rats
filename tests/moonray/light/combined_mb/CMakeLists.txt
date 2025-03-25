# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises motion blur on non-textured bounded lights; i.e. non-textured versions of the following light types:
#
#   CylinderLight
#   DiskLight
#   MeshLight
#   RectLight
#   SphereLight
#   SpotLight
#
# Each light emits a different color to make it easier to see which parts of the scene it affects. This should also
# make it easier to diagnose a problem if the test fails. But if that isn't possible, a robust way to find out if the
# problem lies with a specific light type or applies globally to all lights is to comment out all but one light,
# generate a canonical with a known-good moonray version, then run rats using the branched moonray version under
# test. Then repeat for all light types.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

