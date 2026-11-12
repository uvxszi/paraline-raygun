"""Writes Paraline's indexes.

- index.json: Paraline, the one index Raygun adds. It lists
  - Raygun's first-party extensions, from a Raygun checkout's repo/ folder; their packages stay
    in Raygun's repository and are listed by their address there;
  - the Raygun-format sources in raygun/ (raygun/index.json, written by raygun-ext);
  - the scripts in shosetsu/src/ (Shosetsu's format), if any, with the libraries they need.
  - the Stremio addons in stremio/addons.json, under "addons": Raygun 1.3.0 lists them as
    sources to add, and earlier versions (which don't know them) skip that key;
- lib/: copies of shosetsu/lib/. Raygun reads a script's libraries from lib/ beside the index.
- shosetsu/index.json: the scripts as a Shosetsu repository. Raygun 1.0.0 added this address as
  "Paraline Raygun", so it stays published, and lists nothing while Paraline carries no scripts.

raygun/index.json is left as raygun-ext writes it; Raygun 1.0.0 reads it too.

Every extension in Raygun's extensions/ folder must be published in its repo/ folder at its
current version (`pnpm repo:publish` there), and that commit pushed before this one: the index
points at the packages on GitHub. The same goes for raygun/sources/ and raygun/.

A script's first line is Shosetsu's metadata comment:
`-- {"id":3,"ver":"2.2.6","libVer":"1.0.0",...}`, and each script needs a description in
DESCRIPTIONS that names the licence of the texts it reads. Hashes are SHA-256, in the field
Shosetsu's index calls "md5" for scripts and "hash" for libraries.

Run: python tools/build_index.py [--raygun ../raygun] [--allow-unpublished]
"""

import argparse
import hashlib
import json
import pathlib
import re
import shutil

ROOT = pathlib.Path(__file__).resolve().parent.parent
SHOSETSU = ROOT / "shosetsu"
SOURCES = ROOT / "raygun"
LIB = ROOT / "lib"
NAME = "Paraline"
# Where Raygun's repo/ folder is published.
RAYGUN_REPO = "https://raw.githubusercontent.com/uvxszi/raygun/main/repo/"

# Raygun extensions published in Raygun's own repository but not listed here, since Paraline
# lists only open sources: site scripts for services that aren't openly licensed are added by
# their package's address instead.
NOT_LISTED = {"dev.raygun.noutube", "dev.raygun.twitch"}
ICONS = "https://gitlab.com/shosetsuorg/extensions/-/raw/dev/icons/"
# What each script gives and under which licence, for Raygun's catalogue, by file name.
DESCRIPTIONS = {}
API_VERSION = 1


def fail(message):
    raise SystemExit(f"build_index: {message}")


def header(path):
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.strip():
            return json.loads(line.strip()[2:].strip())
    fail(f"{path}: empty")


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def read_json(path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, ValueError) as error:
        fail(f"could not read {path}: {error}")


def write_json(path, value):
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False) + "\n", encoding="utf-8",
                    newline="\n")


def id_label(text):
    """Raygun's id part for a Shosetsu name: lower case, other characters as "-" (repo.rs)."""
    return re.sub(r"[^a-z0-9]", "-", text.lower()).strip("-")


def checked(entry, folder):
    """An index entry whose package is in `folder` with the size and hash the index gives."""
    package = folder / entry["package"]
    if not package.is_file():
        fail(f"{entry['id']}: {package} is missing")
    data = package.read_bytes()
    if len(data) != entry["size"] or sha256(data) != entry["sha256"]:
        fail(f"{entry['id']}: {package} doesn't match its index entry")
    return dict(entry)


def published(index_path, extensions_dir, how, allow_unpublished):
    """The entries of a Raygun repository folder's index for the extensions in `extensions_dir`
    (folders with a raygun-extension.json), each at the version its manifest gives."""
    listed = {entry["id"]: entry for entry in read_json(index_path)["extensions"]}
    current = {}
    for manifest_path in sorted(extensions_dir.glob("*/raygun-extension.json")):
        manifest = read_json(manifest_path)
        current[manifest["id"]] = manifest["version"]
    behind = [
        f"{extension} {version}"
        for extension, version in sorted(current.items())
        if listed.get(extension, {}).get("version") != version
    ]
    if behind and not allow_unpublished:
        fail(f"not published at their current version: {', '.join(behind)}. {how}")
    for item in behind:
        print(f"not published at its current version yet, so only its published version (if "
              f"any) is listed: {item}")
    for extension in sorted(set(listed) - set(current)):
        print(f"left out {extension}: {extensions_dir} no longer has it")
    return [listed[extension] for extension in sorted(current) if extension in listed]


def raygun_extensions(raygun, allow_unpublished):
    """Raygun's first-party extensions, their packages by their address in Raygun's repository."""
    entries = []
    for entry in published(
        raygun / "repo" / "index.json",
        raygun / "extensions",
        "Run `pnpm repo:publish` in Raygun, commit and push it, then run this again.",
        allow_unpublished,
    ):
        if entry["id"] in NOT_LISTED:
            continue
        entry = checked(entry, raygun / "repo")
        entry["package"] = RAYGUN_REPO + entry["package"]
        if entry.get("icon") and "://" not in entry["icon"]:
            entry["icon"] = RAYGUN_REPO + entry["icon"]
        entries.append(entry)
    return entries


def community_sources(allow_unpublished):
    """The Raygun-format sources in raygun/, their packages under raygun/."""
    entries = []
    for entry in published(
        SOURCES / "index.json",
        SOURCES / "sources",
        "Pack them first: node <raygun>/packages/sdk/bin/raygun-ext.mjs pack-all raygun/sources "
        "--repo raygun",
        allow_unpublished,
    ):
        entry = checked(entry, SOURCES)
        entry["package"] = "raygun/" + entry["package"]
        if entry.get("icon") and "://" not in entry["icon"]:
            entry["icon"] = "raygun/" + entry["icon"]
        entries.append(entry)
    return entries


def stremio_addons():
    """The Stremio addons Paraline lists: entries whose package is the addon's manifest."""
    path = ROOT / "stremio" / "addons.json"
    if not path.is_file():
        return []
    entries = read_json(path)
    for entry in entries:
        package = entry.get("package", "")
        if not (package.startswith("https://") and package.endswith("/manifest.json")):
            fail(f"{path}: {entry.get('id')}'s package must be its manifest's https address")
        if not entry.get("description"):
            fail(f"{path}: {entry.get('id')} needs a description saying what it gives")
        entry.setdefault("sha256", "")
        entry.setdefault("size", 0)
    return sorted(entries, key=lambda entry: entry["id"])


def scripts_and_entries():
    """The Shosetsu scripts, as Shosetsu index entries and as Raygun index entries."""
    scripts, entries = [], []
    for path in sorted((SHOSETSU / "src").glob("*/*.lua")):
        meta = header(path)
        name, lang = path.stem, path.parent.name
        description = DESCRIPTIONS.get(name)
        if not description:
            fail(f"{path}: add its description, naming the licence of its texts, to DESCRIPTIONS")
        data = path.read_bytes()
        icon = f"{ICONS}{name}.png"
        scripts.append({
            "id": meta["id"],
            "name": meta.get("name", name),
            "fileName": name,
            "imageURL": icon,
            "lang": lang,
            "ver": meta["ver"],
            "libVer": meta["libVer"],
            "md5": sha256(data),
            "type": "LuaScript",
        })
        entries.append({
            # The id Raygun gives this script in Shosetsu's repository, so a copy installs as the
            # same source.
            "id": f"shosetsu.{id_label(lang)}.{id_label(name)}",
            "name": meta.get("name", name),
            "version": meta["ver"],
            "apiVersion": API_VERSION,
            "description": description,
            "author": meta.get("author"),
            "provides": ["novel.source"],
            "permissions": {"net": ["*"], "webview": False},
            "contentRating": "safe",
            "lang": lang,
            "package": f"shosetsu/src/{lang}/{path.name}",
            "icon": icon,
            "sha256": sha256(data),
            "size": len(data),
            "format": "shosetsu",
        })
    return scripts, sorted(entries, key=lambda entry: entry["id"])


def libraries():
    return [
        {"name": path.stem, "ver": header(path)["ver"], "url": None,
         "hash": sha256(path.read_bytes())}
        for path in sorted((SHOSETSU / "lib").glob("*.lua"))
    ]


def copy_libraries():
    """lib/ holds exactly shosetsu/lib/'s files, byte for byte (and is left out without any)."""
    wanted = {path.name for path in (SHOSETSU / "lib").glob("*.lua")}
    if wanted:
        LIB.mkdir(exist_ok=True)
    for stale in LIB.glob("*.lua"):
        if stale.name not in wanted:
            stale.unlink()
    for name in sorted(wanted):
        shutil.copyfile(SHOSETSU / "lib" / name, LIB / name)


def main():
    parser = argparse.ArgumentParser(description="Writes Paraline's indexes.")
    parser.add_argument("--raygun", type=pathlib.Path, default=ROOT.parent / "raygun",
                        help="a Raygun checkout (default: ../raygun)")
    parser.add_argument("--allow-unpublished", action="store_true",
                        help="list extensions not yet published at their current version at the "
                             "version that is, instead of stopping")
    arguments = parser.parse_args()
    raygun = arguments.raygun.resolve()
    if not (raygun / "repo" / "index.json").is_file():
        fail(f"{raygun} isn't a Raygun checkout (no repo/index.json); pass --raygun")

    scripts, script_entries = scripts_and_entries()
    libs = libraries()
    first_party = raygun_extensions(raygun, arguments.allow_unpublished)
    community = community_sources(arguments.allow_unpublished)
    extensions = first_party + community + script_entries
    addons = stremio_addons()
    ids = [entry["id"] for entry in extensions + addons]
    duplicates = sorted({extension for extension in ids if ids.count(extension) > 1})
    if duplicates:
        fail("listed twice: " + ", ".join(duplicates))

    SHOSETSU.mkdir(exist_ok=True)
    write_json(SHOSETSU / "index.json",
               {"authors": [], "libraries": libs, "scripts": scripts, "styles": [], "js": []})
    copy_libraries()
    write_json(ROOT / "index.json", {
        "formatVersion": 1,
        "name": NAME,
        "extensions": extensions,
        "addons": addons,
        "libraries": [{key: lib[key] for key in ("name", "ver", "hash")} for lib in libs],
    })
    print(f"index.json: {count(first_party, 'Raygun extension')}, "
          f"{count(community, 'community source')}, {count(script_entries, 'script')}, "
          f"{count(addons, 'Stremio addon')}, "
          f"{count(libs, 'library', 'libraries')}")
    print(f"shosetsu/index.json: {count(scripts, 'script')}")


def count(items, one, many=None):
    return f"{len(items)} {one if len(items) == 1 else many or one + 's'}"


if __name__ == "__main__":
    main()
