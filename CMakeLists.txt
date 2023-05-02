# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required (VERSION 3.23.1)

project(rats)

list(APPEND CMAKE_MESSAGE_CONTEXT ${PROJECT_NAME})
# list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

set(RATS_CANONICAL_PATH "" CACHE PATH "Path to canonical images")
set(RATS_RENDER_RES "1" CACHE STRING "-res command-line argument")
set(RATS_NUM_THREADS "2" CACHE STRING "Number of threads per-render")
option(RATS_GEN_CANONICALS "Enable to generate canonicals" NO)

add_subdirectory(tests)
