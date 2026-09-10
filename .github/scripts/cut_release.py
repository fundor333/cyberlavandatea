#!/usr/bin/env python3
"""Cut a release from CHANGELOG.md's "Unreleased" section.

Reads CHANGELOG.md, and if the "## [Unreleased]" section has content:
  - computes the next semver version (bump from the last git tag, either
    forced via the BUMP env var or inferred from the Keep a Changelog
    category headings present in the section: "Removed" -> major,
    "Added" -> minor, anything else -> patch)
  - rewrites CHANGELOG.md so that section becomes "## [X.Y.Z] - YYYY-MM-DD"
    with a fresh empty "## [Unreleased]" above it
  - bumps the "version" field in package.json to match
  - writes the release notes body to release-notes.md
  - writes `skip` and `version` to $GITHUB_OUTPUT

If the Unreleased section is empty, sets skip=true and changes nothing.
"""
import datetime
import json
import os
import re
import subprocess
import sys

CHANGELOG = "CHANGELOG.md"
PACKAGE_JSON = "package.json"
NOTES_FILE = "release-notes.md"

UNRELEASED_RE = re.compile(r"^## \[Unreleased\]\s*$")
VERSION_HEADING_RE = re.compile(r"^## \[")


def last_tag():
    try:
        out = subprocess.run(
            ["git", "describe", "--tags", "--abbrev=0"],
            capture_output=True, text=True, check=True,
        ).stdout.strip()
        return out
    except subprocess.CalledProcessError:
        return "v0.0.0"


def bump(version, kind):
    major, minor, patch = (int(x) for x in version.split("."))
    if kind == "major":
        return f"{major + 1}.0.0"
    if kind == "minor":
        return f"{major}.{minor + 1}.0"
    return f"{major}.{minor}.{patch + 1}"


def infer_bump(section_lines):
    headings = {
        line.strip("# ").strip()
        for line in section_lines
        if line.startswith("###")
    }
    if "Removed" in headings:
        return "major"
    if "Added" in headings:
        return "minor"
    return "patch"


def write_output(name, value):
    path = os.environ.get("GITHUB_OUTPUT")
    if not path:
        return
    with open(path, "a") as fh:
        fh.write(f"{name}={value}\n")


def main():
    with open(CHANGELOG) as fh:
        lines = fh.readlines()

    start = next((i for i, l in enumerate(lines) if UNRELEASED_RE.match(l)), None)
    if start is None:
        print("No '## [Unreleased]' section found in CHANGELOG.md", file=sys.stderr)
        write_output("skip", "true")
        return

    end = next(
        (i for i in range(start + 1, len(lines)) if VERSION_HEADING_RE.match(lines[i])),
        len(lines),
    )
    section = lines[start + 1:end]
    body = "".join(section).strip("\n")

    if not body:
        print("Unreleased section is empty, nothing to release.")
        write_output("skip", "true")
        return

    forced = os.environ.get("BUMP", "auto").strip().lower()
    kind = forced if forced in ("major", "minor", "patch") else infer_bump(section)

    current = last_tag().lstrip("v")
    version = bump(current, kind)
    today = datetime.date.today().isoformat()

    new_lines = (
        lines[:start]
        + ["## [Unreleased]\n", "\n", f"## [{version}] - {today}\n"]
        + section
        + lines[end:]
    )
    with open(CHANGELOG, "w") as fh:
        fh.writelines(new_lines)

    try:
        with open(PACKAGE_JSON) as fh:
            pkg = json.load(fh)
        pkg["version"] = version
        with open(PACKAGE_JSON, "w") as fh:
            json.dump(pkg, fh, indent=2, ensure_ascii=False)
            fh.write("\n")
    except FileNotFoundError:
        pass

    with open(NOTES_FILE, "w") as fh:
        fh.write(body + "\n")

    print(f"Cutting release v{version} ({kind} bump from {current})")
    write_output("skip", "false")
    write_output("version", version)


if __name__ == "__main__":
    main()
