"""Writes shosetsu/index.json from the scripts and libraries in shosetsu/.

Each script's and library's first line is Shosetsu's metadata comment:
`-- {"id":3,"ver":"2.2.6","libVer":"1.0.0",...}`. Hashes are SHA-256, in the field Shosetsu's
index calls "md5" for scripts and "hash" for libraries.

Run: python tools/build_index.py
"""

import hashlib
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent / "shosetsu"
ICONS = "https://gitlab.com/shosetsuorg/extensions/-/raw/dev/icons/"
# Icons for scripts whose original lists one elsewhere.
ICON_OVERRIDES = {
    "Wattpad": "https://cdn-icons-png.flaticon.com/512/2111/2111715.png",
}


def header(path):
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.strip():
            return json.loads(line.strip()[2:].strip())
    raise SystemExit(f"{path}: empty")


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    scripts = []
    for path in sorted((ROOT / "src").glob("*/*.lua")):
        meta = header(path)
        name = path.stem
        scripts.append({
            "id": meta["id"],
            "name": meta.get("name", name),
            "fileName": name,
            "imageURL": ICON_OVERRIDES.get(name, f"{ICONS}{name}.png"),
            "lang": path.parent.name,
            "ver": meta["ver"],
            "libVer": meta["libVer"],
            "md5": sha256(path),
            "type": "LuaScript",
        })
    libraries = [
        {"name": path.stem, "ver": header(path)["ver"], "url": None, "hash": sha256(path)}
        for path in sorted((ROOT / "lib").glob("*.lua"))
    ]
    index = {"authors": [], "libraries": libraries, "scripts": scripts, "styles": [], "js": []}
    (ROOT / "index.json").write_text(json.dumps(index, indent=2, ensure_ascii=False) + "\n",
                                     encoding="utf-8", newline="\n")
    print(f"{len(scripts)} scripts, {len(libraries)} libraries")


if __name__ == "__main__":
    main()
