#!/usr/bin/env python3
"""
rename_batch.py
---------------
Batch rename files in a directory using a regex pattern and replacement string,
with optional preview (dry-run) mode.

Usage:
    python3 rename_batch.py <directory> <pattern> <replacement> [--dry-run] [--recursive]

Example:
    # Replace spaces with underscores in all .jpg files
    python3 rename_batch.py ~/Photos " " "_" --dry-run

    # Add a prefix to all Python files
    python3 rename_batch.py ./src "" "new_" --recursive

Author: Farhabi Helal <https://github.com/farhabihelal>
"""

from __future__ import annotations

import argparse
import logging
import re
import sys
from pathlib import Path


def rename_files(
    directory: Path,
    pattern: str,
    replacement: str,
    recursive: bool = False,
    dry_run: bool = False,
) -> tuple[int, int]:
    """
    Rename files matching *pattern* with *replacement*.

    Returns
    -------
    tuple[int, int]
        (renamed_count, skipped_count)
    """
    if not directory.is_dir():
        raise NotADirectoryError(f"'{directory}' is not a valid directory.")

    compiled = re.compile(pattern)
    renamed = 0
    skipped = 0

    glob_fn = directory.rglob if recursive else directory.glob
    items = sorted(glob_fn("*"))

    for item in items:
        if item.is_dir():
            continue

        new_name = compiled.sub(replacement, item.name)

        if new_name == item.name:
            logging.debug("No change: %s", item.name)
            skipped += 1
            continue

        new_path = item.parent / new_name

        if dry_run:
            logging.info("[DRY-RUN] '%s'  →  '%s'", item.name, new_name)
            renamed += 1
            continue

        if new_path.exists():
            logging.warning("Skipping '%s': target '%s' already exists.", item.name, new_name)
            skipped += 1
            continue

        item.rename(new_path)
        logging.info("Renamed '%s'  →  '%s'", item.name, new_name)
        renamed += 1

    return renamed, skipped


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Batch rename files using regex.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument("directory",    type=Path, help="Target directory")
    parser.add_argument("pattern",      type=str,  help="Regex pattern to match in filenames")
    parser.add_argument("replacement",  type=str,  help="Replacement string (supports back-references)")
    parser.add_argument("--dry-run",    action="store_true", help="Preview renames without executing")
    parser.add_argument("--recursive",  action="store_true", help="Process sub-directories recursively")
    parser.add_argument("--verbose", "-v", action="store_true", help="Enable verbose output")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(format="%(levelname)s: %(message)s", level=level)

    try:
        renamed, skipped = rename_files(
            args.directory,
            args.pattern,
            args.replacement,
            recursive=args.recursive,
            dry_run=args.dry_run,
        )
    except (NotADirectoryError, re.error) as exc:
        logging.error("%s", exc)
        return 1

    action = "Would rename" if args.dry_run else "Renamed"
    print(f"\n✅ {action} {renamed} file(s), skipped {skipped} file(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
