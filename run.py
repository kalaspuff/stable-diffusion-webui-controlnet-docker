import os
import subprocess
import sys


def on_start():
    print("---------------")
    print("Running script './on_start.sh' to download models ...")
    print("---------------")
    result = subprocess.run("./on_start.sh", shell=True, env=os.environ)
    if result.returncode != 0:
        raise RuntimeError(f"Error executing ./on_start.sh [exit code: {result.returncode}]")


def start():
    print("---------------")
    print(f"Launching {'API server' if '--nowebui' in sys.argv else 'Web UI'} with arguments: {' '.join(sys.argv[1:])}")
    print("---------------")
    import webui  # type: ignore  # noqa

    if "--nowebui" in sys.argv:
        webui.api_only()
    else:
        webui.webui()


def set_options():
    import torch  # type: ignore  # noqa

    if not torch.cuda.is_available():
        # If no GPU is available, uninstall xformers and apply "--precision full --no-half --use-cpu all" to sys.argv.
        os.system(f"{sys.executable} -m pip uninstall -y xformers")
        sys.argv.extend(
            [
                "--precision",
                "full",
                "--no-half",
                "--use-cpu",
                "all",
            ]
        )
    else:
        # Applies "--force-enable-xformers --xformers" to sys.argv when there's a GPU present.
        sys.argv.extend(["--force-enable-xformers", "--xformers"])

    is_shared_ui = str(os.environ.get("IS_SHARED_UI", "") or "").strip().lower() not in ("", "0", "false", "none", "no")
    if not is_shared_ui:
        # Provide access to extensions only if IS_SHARED_UI isn't set.
        sys.argv.extend(["--enable-insecure-extension-access"])


if __name__ == "__main__":
    set_options()
    on_start()
    start()
