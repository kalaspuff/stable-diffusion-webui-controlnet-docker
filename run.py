import os
import subprocess
import sys


def on_start():
    print("---------------")
    print("Starting script './on_start.sh' to downloads models ...")
    print("---------------")
    result = subprocess.run("./on_start.sh", shell=True, env=os.environ)
    if result.returncode != 0:
        raise RuntimeError(f"Error executing ./on_start.sh [exit code: {result.returncode}]")


def start():
    on_start()

    print("---------------")
    print(f"Launching {'API server' if '--nowebui' in sys.argv else 'Web UI'} with arguments: {' '.join(sys.argv[1:])}")
    print("---------------")
    import webui  # type: ignore  # noqa
    if '--nowebui' in sys.argv:
        webui.api_only()
    else:
        webui.webui()


if __name__ == "__main__":
    start()
