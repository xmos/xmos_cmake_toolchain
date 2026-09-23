# Copyright 2023-2026 XMOS LIMITED.
# This Software is subject to the terms of the XMOS Public Licence: Version 1.

"""Build and run basic applications using the xmos cmake toolchain
and check there are no warnings"""

import shutil
import os
from pathlib import Path
import copy
from subprocess import run, PIPE

ROOT = str(Path(__file__).parent.parent)
TOOLCHAIN = f"{ROOT}/{{}}.cmake"

CWD = Path(__file__).parent
BUILD_PATH = CWD / "build"
APP_DIR = CWD / "test_app"

def check(proc):
    """Check the output of proc contains no errors or warnings"""
    print(proc.stdout)
    print(proc.stderr)
    assert 0 == proc.returncode, proc.stderr
    assert "warning" not in proc.stdout.lower(), proc.stdout + proc.stderr
    assert "error" not in proc.stdout.lower(), proc.stdout
    assert "warning" not in proc.stderr.lower(), proc.stderr
    assert "error" not in proc.stderr.lower(), proc.stderr

def run_cmake_toolchain_test(toolchain):
    """Build the test_app with a toolchain and run each app, checking it returns 0"""
    build_dir = BUILD_PATH  / "basic" / toolchain    
    if build_dir.exists():
        shutil.rmtree(build_dir)
    
    run(["cmake", "--version"], check=True)

    proc = run(
        [
            "cmake",
            "-B",
            str(build_dir),
            "-S",
            str(APP_DIR),
            f"-DCMAKE_TOOLCHAIN_FILE={TOOLCHAIN.format(toolchain)}",
        ],
        text=True,
        stdout=PIPE,
        stderr=PIPE,
    )
    check(proc)

    proc = run(
        ["cmake", "--build", "."],
        cwd=str(build_dir),
        text=True,
        stdout=PIPE,
        stderr=PIPE,
    )
    check(proc)
    proc = run(["ctest"], cwd=str(build_dir), text=True, stdout=PIPE, stderr=PIPE)
    check(proc)


def run_missing_xtc_env_test(toolchain):
    """Build should fail if SetEnv is not run"""
    build_dir = BUILD_PATH / "env" / toolchain    
    if build_dir.exists():
        shutil.rmtree(build_dir)
    
    # remove tools path
    env = dict(**os.environ)
    del env["XMOS_TOOL_PATH"]

    # It was seen that in Jenkins CI the tools are in the path more than once so remove them all
    path = env["PATH"].split(":")
    for item in copy.deepcopy(path):
        if "XTC" in item and "XMOS" in item:
            path.remove(item)
    env["PATH"] = ":".join(path)

    proc = run(
        [
            "cmake",
            "-B",
            str(build_dir),
            "-S",
            str(APP_DIR),
            f"-DCMAKE_TOOLCHAIN_FILE={TOOLCHAIN.format(toolchain)}",
        ],
        env=env,
    )

    ERR_MSG = "cmake configuration succeeded even though the XTC environment was not set"
    assert (0 != proc.returncode), ERR_MSG

def test_cmake_toolchain(toolchain):
    run_cmake_toolchain_test(toolchain)
    run_missing_xtc_env_test(toolchain)


if __name__ == "__main__":
    run_cmake_toolchain_test("xs3a")
