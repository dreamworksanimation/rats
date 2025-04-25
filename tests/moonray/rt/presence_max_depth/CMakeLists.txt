# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# A Cornell Box containing two planes with presence = 0.1.  The rear plane is opaque
# because we have specified ["max presence depth"] = 1.  The rear wall of the Cornell
# Box is removed to better show the effect.
# Tests that once we have reached max presence depth, the presence is always 1.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

