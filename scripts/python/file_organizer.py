#!/usr/bin/env python3
"""
file_organizer.py
-----------------
Recursively organizes files in a directory by their extension into
categorized sub-folders (Images, Documents, Videos, Code, Archives, Others).

Usage:
    python3 file_organizer.py <target_directory> [--dry-run] [--verbose]

Author: Farhabi Helal <https://github.com/farhabihelal>
"""

from __future__ import annotations

import argparse
import logging
import shutil
import sys
from pathlib import Path

# ---------------------------------------------------------------------------
# Category → extension mapping
# ---------------------------------------------------------------------------
CATEGORIES: dict[str, list[str]] = {
    "Images":    [".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg", ".webp", ".heic", ".tiff"],
    "Videos":    [".mp4", ".mkv", ".mov", ".avi", ".wmv", ".flv", ".webm"],
    "Audio":     [".mp3", ".wav", ".flac", ".aac", ".ogg", ".m4a"],
    "Documents": [".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".txt", ".md", ".csv"],
    "Code":      [".py", ".js", ".ts", ".java", ".c", ".cpp", ".h", ".go", ".rs", ".sh", ".bash",
                  ".zsh", ".rb", ".php", ".html", ".css", ".json", ".yaml", ".yml", ".toml", ".xml"],
    "Archives":  [".zip", ".tar", ".gz", ".bz2", ".xz", ".7z", ".rar"],
    "Others":    [],  # catch-all
}

_EXT_TO_CATEGORY: dict[str, str] = {
    ext: cat
    for cat, exts in CATEGORIES.items()
    for ext in exts
}


def get_category(suffix: str) -> str:
    """Return the category name for a given file extension."""
    return _EXT_TO_CATEGORY.get(suffix.lower(), "Others")


def organize(
    directory: Path,
    dry_run: bool = False,
    verbose: bool = False,
) -> dict[str, int]:
    """
    Organize files in *directory* into category sub-folders.

    Parameters
    ----------
    directory : Path
        Target directory to organize.
    dry_run   : bool
        If True, print planned moves without executing them.
    verbose   : bool
        Enable verbose logging.

    Returns
    -------
    dict[str, int]
        Count of files moved per category.
    """
    if not directory.is_dir():
        raise NotADirectoryError(f"'{directory}' is not a valid directory.")

    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(format="%(levelname)s: %(message)s", level=level)

    stats: dict[str, int] = {}

    for item in sorted(directory.iterdir()):
        if item.is_dir():
            logging.debug("Skipping directory: %s", item.name)
            continue

        category = get_category(item.suffix)
        dest_dir = directory / category
        dest_file = dest_dir / item.name

        stats[category] = stats.get(category, 0) + 1

        if dry_run:
            logging.info("[DRY-RUN] Would move '%s' → '%s/'", item.name, category)
            continue

        dest_dir.mkdir(exist_ok=True)

        # Handle name collision
        if dest_file.exists():
            stem = item.stem
            suffix = item.suffix
            counter = 1
            while dest_file.exists():
                dest_file = dest_dir / f"{stem}_{counter}{suffix}"
                counter += 1

        try:
            shutil.move(str(item), str(dest_file))
        except (OSError, shutil.Error) as exc:
            logging.warning("Could not move '%s': %s", item.name, exc)
            stats[category] = stats.get(category, 0) - 1
            continue
        logging.info("Moved '%s' → '%s/'", item.name, category)

    return stats


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Organize files in a directory by type.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument("directory", type=Path, help="Target directory to organize")
    parser.add_argument("--dry-run", action="store_true", help="Preview changes without moving files")
    parser.add_argument("--verbose", "-v", action="store_true", help="Enable verbose output")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)

    try:
        stats = organize(args.directory, dry_run=args.dry_run, verbose=args.verbose)
    except NotADirectoryError as exc:
        logging.error("%s", exc)
        return 1

    print("\n📁 Summary:")
    for category, count in sorted(stats.items()):
        action = "Would move" if args.dry_run else "Moved"
        print(f"  {action} {count} file(s) → {category}/")

    return 0


if __name__ == "__main__":
    sys.exit(main())
