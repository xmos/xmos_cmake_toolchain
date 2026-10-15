# Define system and processor
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR riscv32)

# CMake versions 3.20 and newer now require the ASM dialect to be specified
set(ASM_DIALECT "")

if(DEFINED ENV{XMOS_TOOL_PATH} AND NOT "$ENV{XMOS_TOOL_PATH}" STREQUAL "")
	file(TO_CMAKE_PATH "$ENV{XMOS_TOOL_PATH}" XMOS_TOOL_PATH_CMAKE)
	set(XMOS_RV_TOOLCHAIN_BIN "${XMOS_TOOL_PATH_CMAKE}/riscv32-clang/bin")
	set(CMAKE_PROGRAM_PATH "${XMOS_RV_TOOLCHAIN_BIN}")
else()
	message(FATAL_ERROR
		"Environment variable XMOS_TOOL_PATH is not set or empty. "
		"Please set it to the path of the XMOS toolchain.")
endif()

find_program(CMAKE_C_COMPILER NAMES clang PATHS "${XMOS_RV_TOOLCHAIN_BIN}" NO_DEFAULT_PATH REQUIRED)
find_program(CMAKE_CXX_COMPILER NAMES clang++ PATHS "${XMOS_RV_TOOLCHAIN_BIN}" NO_DEFAULT_PATH REQUIRED)
set(CMAKE_ASM_COMPILER "${CMAKE_C_COMPILER}")

set(CMAKE_AR "${XMOS_RV_TOOLCHAIN_BIN}/llvm-ar" CACHE FILEPATH "Archiver")
set(CMAKE_RANLIB "${XMOS_RV_TOOLCHAIN_BIN}/llvm-ranlib")
set(CMAKE_NM "${XMOS_RV_TOOLCHAIN_BIN}/llvm-nm")
set(CMAKE_STRIP "${XMOS_RV_TOOLCHAIN_BIN}/llvm-strip")
set(CMAKE_OBJCOPY "${XMOS_RV_TOOLCHAIN_BIN}/llvm-objcopy")
set(CMAKE_OBJDUMP "${XMOS_RV_TOOLCHAIN_BIN}/llvm-objdump")
set(CMAKE_LINKER "${XMOS_RV_TOOLCHAIN_BIN}/clang")
set(CMAKE_C_COMPILER_AR "${XMOS_RV_TOOLCHAIN_BIN}/llvm-ar")
set(CMAKE_CXX_COMPILER_AR "${XMOS_RV_TOOLCHAIN_BIN}/llvm-ar")
set(CMAKE_ASM_COMPILER_AR "${XMOS_RV_TOOLCHAIN_BIN}/llvm-ar")

set(CMAKE_C_COMPILER_TARGET riscv32-xmos-unknown-elf)
set(CMAKE_CXX_COMPILER_TARGET riscv32-xmos-unknown-elf)
set(CMAKE_ASM_COMPILER_TARGET riscv32-xmos-unknown-elf)

set(CMAKE_C_FLAGS_INIT "-mcpu=xmos-vx4b")
set(CMAKE_CXX_FLAGS_INIT "-mcpu=xmos-vx4b -std=c++11")
set(CMAKE_ASM_FLAGS_INIT "-mcpu=xmos-vx4b")
set(CMAKE_EXE_LINKER_FLAGS_INIT "-mcpu=xmos-vx4b -lxcore")
set(CMAKE_EXECUTABLE_SUFFIX ".elf")
