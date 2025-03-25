# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the "medium_material" and "medium_geometry" attributes, which
# allow you to set a material the camera is "inside". In this scene, the camera
# is halfway inside a water box, which is a rectangular prism with a water material
# applied to it. The far right sphere also has a water material applied to it.
# If the "medium_material" and "medium_geometry" are working correctly, when
# applied to the camera, the rightmost sphere should disappear where it is
# underneath the water. Some of the camera rays do not enter the water box,
# and when they intersect with the sphere, they bend, since they are going from
# an IOR of 1.0 to an IOR of 1.33. Some of the camera rays enter the water box,
# and when they encounter the sphere, the rays should go right through it,
# since both the sphere and the water box have an IOR of 1.33.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

