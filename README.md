# Toolchain for XMOS xcore processor tools.

## Overview

This repo contains toolchain files that allow building of XMOS xcore-200 (xs2a architecture) and xcore.ai (xs3a architecture) targets under `cmake`.
This repo is usually included as a submodule within a project and the ``xs2a.cmake`` or ``xs3a.cmake`` is passed to the cmake build command using the 
`-DCMAKE_TOOLCHAIN_FILE` argument. Please see below for an example of this:

```
cmake -B build -DCMAKE_TOOLCHAIN_FILE=modules/xmos_cmake_toolchain/xs3a.cmake
```

If using `NMake` pass the ```-G "NMake Makefiles"``` argument or if using `Ninja` pass the ```-G "Ninja"``` argument additionally to the above `cmake` command.

Once the `cmake` stage has completed the actual build can commence. This is typically done using `make` on Linux or Mac hosts and with `NMake` or `Ninja` on Windows hosts. Ensure you are running this from the ```/build``` directory specified in the `cmake` stage.

## Tests

A basic test suite checks the defined toolchains against a few cmake versions to ensure they build as expected. To run the tests locally do:

```
pip install -Ur requirements.txt
cd test
tox run
```
