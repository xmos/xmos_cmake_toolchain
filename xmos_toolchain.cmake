set(CMAKE_SYSTEM_NAME XMOS)
set(CMAKE_SYSTEM_PROCESSOR xcore)

set(CMAKE_C_COMPILER "xcc")
set(CMAKE_XC_COMPILER  "xcc")
set(CMAKE_CXX_COMPILER  "xcc")
set(CMAKE_ASM_COMPILER  "xcc")

# TODO move these to respective CMakeFindBinUtils.cmake files
set(CMAKE_AR "xmosar")
set(CMAKE_C_COMPILER_AR "xmosar")
set(CMAKE_XC_COMPILER_AR "xmosar")
set(CMAKE_CXX_COMPILER_AR "xmosar")
set(CMAKE_ASM_COMPILER_AR "xmosar")
set(CMAKE_RANLIB "")

# TODO these will become redundant
set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_XC_COMPILER_FORCED TRUE)
set(CMAKE_CXX_COMPILER_FORCED TRUE)
set(CMAKE_ASM_COMPILER_FORCED TRUE)

# TODO these will become redundant
set(CMAKE_C_FLAGS "" CACHE STRING "C Compiler Base Flags" FORCE)
set(CMAKE_XC_FLAGS "" CACHE STRING "XC Compiler Base Flags" FORCE)
set(CMAKE_EXE_LINKER_FLAGS "" CACHE INTERNAL "" FORCE)
