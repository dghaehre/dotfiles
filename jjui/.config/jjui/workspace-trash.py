"""Guarded, macOS Trash-based removal, called after confirmation in jjui.

No recursive deletion. Resolve registered paths and repository pointers rather
than reconstructing paths from workspace names. --check performs no mutations.
"""
import argparse
from pathlib import Path
import shutil
import subprocess
import sys


def jj(where, *args):
    result = subprocess.run(
        ["jj", "--no-pager", "--color=never", "-R", str(where), *args],
        text=True, capture_output=True,
    )
    if result.returncode:
        raise RuntimeError(result.stderr.strip() or result.stdout.strip())
    return result.stdout.removesuffix("\n")


def repo_path(workspace):
    pointer = workspace / ".jj" / "repo"
    if pointer.is_file():
        return (pointer.parent / pointer.read_text().strip()).resolve(strict=True)
    return pointer.resolve(strict=True)


def inside(path, directory):
    return path == directory or directory in path.parents


def validate(name, expected, current):
    if not expected:
        raise RuntimeError("Workspace directory is unavailable; use forget-only instead")
    current = Path(current).resolve(strict=True)
    registered = jj(current, "--ignore-working-copy", "workspace", "root", "--name", name)
    target = Path(registered).resolve(strict=True)
    if target != Path(expected).resolve(strict=True):
        raise RuntimeError("Workspace directory changed since it was selected")
    if name == "default" or inside(current, target):
        raise RuntimeError("Refusing to remove the default/current workspace or its parent")
    if target in (Path("/"), Path.home().resolve()):
        raise RuntimeError("Refusing to remove a root or home directory")
    store = repo_path(current)
    if repo_path(target) != store:
        raise RuntimeError("Workspace does not belong to the current repository")
    if inside(store, target) or not (target / ".jj" / "repo").is_file():
        raise RuntimeError("Refusing to remove the workspace containing the shared repository")
    # Ensure the path still denotes the selected workspace, not a replaced directory.
    local_name = jj(target, "--ignore-working-copy", "log", "-r", "@", "--no-graph",
                    "-T", 'working_copies.map(|w| w.name()).join("\\n")')
    if name not in local_name.splitlines():
        raise RuntimeError("Selected workspace identity no longer matches its directory")
    roots = jj(current, "--ignore-working-copy", "workspace", "list", "-T", 'self.root() ++ "\\n"')
    for root in roots.splitlines():
        if root:
            other = Path(root).resolve()
            if other != target and inside(other, target):
                raise RuntimeError("Refusing to remove a directory containing another workspace")
    trash = shutil.which("trash")
    if not trash:
        raise RuntimeError("The macOS trash command is required; directory will not be deleted")
    return target, trash


def remove(name, expected, current, check=False):
    target, trash = validate(name, expected, current)
    if check:
        print(f"Ready to forget {name} and move {target} to Trash")
        return
    # Capture tracked/unignored edits before detaching. Ignored files stay in the
    # directory and are recoverable from Trash, not from jj's operation log.
    jj(target, "status")
    target, trash = validate(name, expected, current)
    jj(current, "workspace", "forget", "--", name)
    result = subprocess.run([trash, str(target)], text=True, capture_output=True)
    if result.returncode:
        raise RuntimeError(f"Forgot {name}, but could not trash {target}. "
                           f"Inspect that path; it may still be present. {result.stderr.strip()}")
    print(f"Forgot {name}; directory moved to Trash (recoverable in Finder)")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("name")
    parser.add_argument("expected")
    parser.add_argument("current")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    try:
        remove(args.name, args.expected, args.current, args.check)
    except (OSError, RuntimeError) as error:
        sys.exit(str(error))
