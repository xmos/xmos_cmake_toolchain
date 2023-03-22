"""Build and run basic applications using the xmos cmake toolchain
and check there are no warnings"""
import pytest
import shutil
import os
from pathlib import Path
from subprocess import run, PIPE

ROOT = str(Path(__file__).parent.parent)
TOOLCHAIN = f"{ROOT}/{{}}.cmake"


def check(proc):
    """Check the output of proc contains no errors or warnings"""
    print(proc.stdout)
    print(proc.stderr)
    assert 0 == proc.returncode, proc.stderr
    assert "warning" not in proc.stdout.lower(), proc.stdout + proc.stderr
    assert "error" not in proc.stdout.lower(), proc.stdout
    assert "warning" not in proc.stderr.lower(), proc.stderr
    assert "error" not in proc.stderr.lower(), proc.stderr


@pytest.mark.parametrize("toolchain", ["xs3a", "xs2a"])
def test_cmake_toolchain(toolchain):
    """Build the test_app with both toolchains and run each app, checking it returns 0"""
    build_dir = (
        Path(__file__).parent / "build/basic" / os.environ["CMAKE_ENV"] / toolchain
    )
    if build_dir.exists():
        shutil.rmtree(build_dir)
    app_dir = Path(__file__).parent / "test_app"
    run(["cmake", "--version"], check=True)

    proc = run(
        [
            "cmake",
            "-B",
            str(build_dir),
            "-S",
            str(app_dir),
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


@pytest.mark.parametrize("toolchain", ["xs3a", "xs2a"])
def test_fails_if_no_xtc_env(toolchain):
    """Build should fail if SetEnv is not run"""
    build_dir = (
        Path(__file__).parent / "build/env" / os.environ["CMAKE_ENV"] / toolchain
    )
    if build_dir.exists():
        shutil.rmtree(build_dir)
    app_dir = Path(__file__).parent / "test_app"

    env = dict(**os.environ)
    del env["XMOS_TOOL_PATH"]
    proc = run(
        [
            "cmake",
            "-B",
            str(build_dir),
            "-S",
            str(app_dir),
            f"-DCMAKE_TOOLCHAIN_FILE={TOOLCHAIN.format(toolchain)}",
        ],
        env=env,
    )

    assert (
        0 != proc.returncode
    ), "cmake configuration succeeded even though the XTC environment was not set"
