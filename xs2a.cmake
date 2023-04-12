
# Temporary fix until CMAKE_SYSTEM_NAME is updated to Generic, this 
# allows cmake to find the Compiler/ and Platform/ directories
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

# Deprecation warning: CMAKE_SYSTEM_NAME will eventually be changed to "Generic".
# Use CMAKE_SYSTEM_PROCESSOR to determine if the build is targetting an xcore. see
# issue #5 
set(CMAKE_SYSTEM_NAME XCORE_XS2A)
set(CMAKE_SYSTEM_PROCESSOR XCORE_XS2A) 

# CMake versions 3.20 and newer now require the ASM dialect to be specified
set(ASM_DIALECT "")

if(NOT DEFINED ENV{XMOS_TOOL_PATH})
    message(FATAL_ERROR "XTC Environment has not been activated. This must be done before running cmake using the SetEnv script.")
endif()

if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL Windows)
    file(TO_CMAKE_PATH "$ENV{XMOS_TOOL_PATH}/bin/xcc.exe" XMOS_TOOL_XCC)
    file(TO_CMAKE_PATH "$ENV{XMOS_TOOL_PATH}/bin/xmosar.exe" XMOS_TOOL_XMOSAR)
else()
    file(TO_CMAKE_PATH "$ENV{XMOS_TOOL_PATH}/bin/xcc" XMOS_TOOL_XCC)
    file(TO_CMAKE_PATH "$ENV{XMOS_TOOL_PATH}/bin/xmosar" XMOS_TOOL_XMOSAR)
endif()

set(CMAKE_C_COMPILER "${XMOS_TOOL_XCC}")
set(CMAKE_CXX_COMPILER  "${XMOS_TOOL_XCC}")
set(CMAKE_ASM_COMPILER  "${XMOS_TOOL_XCC}")
set(CMAKE_AR "${XMOS_TOOL_XMOSAR}" CACHE FILEPATH "Archiver")
set(CMAKE_C_COMPILER_AR "${XMOS_TOOL_XMOSAR}")
set(CMAKE_CXX_COMPILER_AR "${XMOS_TOOL_XMOSAR}")
set(CMAKE_ASM_COMPILER_AR "${XMOS_TOOL_XMOSAR}")

if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL Windows)
    SET(CMAKE_C_USE_RESPONSE_FILE_FOR_OBJECTS 1)
    SET(CMAKE_C_USE_RESPONSE_FILE_FOR_INCLUDES 1)
    SET(CMAKE_C_RESPONSE_FILE_LINK_FLAG "@")

    SET(CMAKE_CXX_USE_RESPONSE_FILE_FOR_OBJECTS 1)
    SET(CMAKE_CXX_USE_RESPONSE_FILE_FOR_INCLUDES 1)
    SET(CMAKE_CXX_RESPONSE_FILE_LINK_FLAG "@")

    SET(CMAKE_ASM_USE_RESPONSE_FILE_FOR_OBJECTS 1)
    SET(CMAKE_ASM_USE_RESPONSE_FILE_FOR_INCLUDES 1)
    SET(CMAKE_ASM_RESPONSE_FILE_LINK_FLAG "@")
endif()

if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL Windows)
else()
    set(CMAKE_RANLIB "echo")
endif()

set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_CXX_COMPILER_FORCED TRUE)
set(CMAKE_ASM_COMPILER_FORCED TRUE)
set(CMAKE_ASM_COMPILER_ID XCC)

set(CMAKE_C_FLAGS "-march=xs2a" CACHE STRING "C Compiler Base Flags" FORCE)
set(CMAKE_CXX_FLAGS "-march=xs2a -std=c++11" CACHE STRING "C++ Compiler Base Flags" FORCE)
set(CMAKE_ASM_FLAGS "-march=xs2a" CACHE STRING "ASM Compiler Base Flags" FORCE)
set(CMAKE_EXE_LINKER_FLAGS "" CACHE INTERNAL "" FORCE)
set(CMAKE_EXECUTABLE_SUFFIX_C   .xe CACHE INTERNAL "" FORCE)
set(CMAKE_EXECUTABLE_SUFFIX_CXX .xe CACHE INTERNAL "" FORCE)
set(CMAKE_EXECUTABLE_SUFFIX_ASM .xe CACHE INTERNAL "" FORCE)

set(CMAKE_USER_MAKE_RULES_OVERRIDE "${CMAKE_CURRENT_LIST_DIR}/xc_override.cmake")
