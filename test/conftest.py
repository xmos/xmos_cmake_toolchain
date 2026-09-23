import pytest

def pytest_addoption(parser):
    parser.addoption(
        "--toolchain",
        nargs="?",
        const="xs3a",
        choices=["xs3a", "xs2a", "vx4_xcc", "vx4_clang"],
        default="xs3a",
        help="toolchain to test (default: xs3a; may be passed without a value)",
    )

@pytest.fixture
def toolchain(request):
    return request.config.getoption("--toolchain")
