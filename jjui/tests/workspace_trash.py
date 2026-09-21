"""Safety/integration checks. Trash is mocked; tests never touch the user's Trash."""
import importlib.util
from pathlib import Path
import subprocess
import sys
from unittest.mock import patch

config, temp = map(Path, sys.argv[1:])
spec = importlib.util.spec_from_file_location("workspace_trash", config / "workspace-trash.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
main = temp / "main"


def jj(*args, repo=main):
    return module.jj(repo, *args)


def reject(name, path, current, expected):
    try:
        module.validate(name, str(path), str(current))
    except (RuntimeError, OSError) as error:
        assert expected in str(error), str(error)
    else:
        raise AssertionError(f"Unsafe target accepted: {name}")


reject("default", main, main, "default/current")
reject("second", temp / "second", temp / "second", "default/current")
jj("workspace", "rename", "primary")
reject("primary", main, temp / "second", "shared repository")
target = temp / "trash ' space"
jj("workspace", "add", "--name", "disposable", str(target))
reject("disposable", temp / "second", main, "changed since")
child = target / "nested"
jj("workspace", "add", "--name", "nested", str(child))
reject("disposable", target, main, "containing another workspace")
jj("workspace", "forget", "nested")
with patch.object(module.shutil, "which", return_value=None):
    reject("disposable", target, main, "trash command")

with patch.object(module.subprocess, "run", wraps=subprocess.run) as run:
    module.remove("disposable", str(target), str(main), check=True)
    assert not any("forget" in call.args[0] or call.args[0][0].endswith("/trash")
                   for call in run.call_args_list), "Preflight mutated the repo"

# Record a file that has not been snapshotted; removal must preserve it in jj.
(target / "unsnapshotted.txt").write_text("preserve this\n")
original_run = subprocess.run
trashed = []


def fake_trash(argv, **kwargs):
    if argv[0] == module.shutil.which("trash"):
        trashed.append(argv)
        return subprocess.CompletedProcess(argv, 0, "", "")
    return original_run(argv, **kwargs)


with patch.object(module.subprocess, "run", side_effect=fake_trash):
    module.remove("disposable", str(target), str(main))
assert trashed == [[module.shutil.which("trash"), str(target)]]
assert "disposable" not in jj("workspace", "list", "-T", 'name ++ "\\n"').splitlines()
assert jj("log", "-r", 'files(root:"unsnapshotted.txt")', "--no-graph", "-T", "commit_id")

# A failed Trash operation must report the partial result, keeping files intact.
failure = temp / "trash-failure"
jj("workspace", "add", "--name", "failure", str(failure))


def failing_trash(argv, **kwargs):
    if argv[0] == module.shutil.which("trash"):
        return subprocess.CompletedProcess(argv, 1, "", "test failure")
    return original_run(argv, **kwargs)


with patch.object(module.subprocess, "run", side_effect=failing_trash):
    try:
        module.remove("failure", str(failure), str(main))
    except RuntimeError as error:
        assert "Forgot failure, but could not trash" in str(error)
    else:
        raise AssertionError("Trash failure was ignored")
assert failure.is_dir()
print("PASS: current/default/store/nested/path guards, read-only preflight, snapshot, Trash success/failure")
