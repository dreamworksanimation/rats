# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# -*- coding: utf-8 -*-

name = 'orats'

@early()
def version():
    """
    Increment the build in the version.
    """
    from json import load
    _version = '1.0'
    from rezbuild import earlybind
    return earlybind.version(this, _version)

description = 'MoonRay RATS test suite'

authors = [
    'PSW Rendering and Shading',
    'moonbase-dev@dreamworks.com'
]

requires = [
    'openimageio-2.3.20.0.x',
    'cmake-3.23',
]

build_command = ("[ {install} ] && "
                 "rsync -tavz {root}/cmake `printenv REZ_BUILD_INSTALL_PATH` || "
                 "echo No --install flag found, build\(s\) are no-ops.")

def commands():
    prependenv('CMAKE_MODULE_PATH', '{root}/cmake')

uuid = '8356f8f4-4f9a-473c-8036-4f32877e3810'

config_version = 0
