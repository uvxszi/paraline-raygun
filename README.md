# Paraline

One extension repository for [Raygun](https://github.com/uvxszi/raygun): Raygun's own extensions, community sources, and maintained copies of novel sources whose sites changed.

Only sources for legitimate sites are listed: official APIs, openly licensed and public-domain collections, free web-novel platforms and writing communities. Nothing here scrapes unlicensed copies or gets around a site's bot checks.

## Adding it

New installs of Raygun start with Paraline. To add it again, open Browse → Extensions → Repositories and add Paraline from the suggestions, or add this address:

```
https://raw.githubusercontent.com/uvxszi/paraline-raygun/main/index.json
```

Raygun 1.0.0 used two separate addresses, which stay published: `shosetsu/index.json` (the novel sources, also readable by [Shosetsu](https://shosetsu.app)) and `raygun/index.json` (the community sources). Newer versions of Raygun replace them with Paraline.

## Contents

| Part | Where | What |
| --- | --- | --- |
| Raygun extensions | Raygun's repository (`repo/` in `uvxszi/raygun`) | Every first-party extension of Raygun, listed by its address there. |
| Community sources | `raygun/` | Sources in Raygun's format, maintained here. |
| Novel sources | `shosetsu/` | Shosetsu scripts for legitimate sites, fixed where the site changed. Each keeps the id of the original, so it installs as an update over it. |
| Stremio addons | [`stremio/addons.md`](stremio/addons.md) | Addresses of legal addons for Raygun's Addons page. |

### Community sources

| Source | Version | What it does |
| --- | --- | --- |
| Openverse audio | 1.0.1 | Openly licensed songs from Openverse (Jamendo, Freesound, Wikimedia Commons…): search and full streams, no account. |

### Novel sources

| Source | Version | What was fixed |
| --- | --- | --- |
| Syosetsu (ja) | 2.2.6 | Search and rankings read the desktop layout as well as the phone one. Chapters use the current title markup, and the text includes the foreword and afterword. |
| Wattpad (en) | 1.0.8 | Stories and chapters come from Wattpad's JSON and text endpoints instead of its pages, whose generated class names change with every Wattpad release. Long parts arrive whole. |

### Not included

Sources whose sites answer every request with a bot check (Royal Road, Scribble Hub, Honeyfeed, FiMFiction, FanFiction.Net, Inkitt, the SpaceBattles and AltHistory threads) are not included: getting around those checks is outside this repository's rules. Sources that work as published come from their own repositories (Shosetsu's, Nuclear's), which Raygun also suggests.

## Layout

| Path | What | Written by |
| --- | --- | --- |
| `index.json` | Paraline's index, in Raygun's format | `tools/build_index.py` |
| `lib/` | Copies of `shosetsu/lib/`: Raygun reads a script's libraries from `lib/` beside the index | `tools/build_index.py` |
| `raygun/sources/<name>/` | A community source: `raygun-extension.json`, `src/`, built `dist/` | hand, then `raygun-ext` |
| `raygun/packages/`, `raygun/index.json` | The community sources' packages and index | `raygun-ext pack-all` |
| `shosetsu/src/<lang>/`, `shosetsu/lib/` | Novel scripts and the libraries they use | hand |
| `shosetsu/index.json` | The novel sources as a Shosetsu repository | `tools/build_index.py` |
| `stremio/addons.md` | Stremio addon addresses | hand |

## Publishing

Paraline lists Raygun's extensions by their address in Raygun's repository, so Raygun is published first. The commands below expect a Raygun checkout beside this one (`../raygun`) with its dependencies installed (`pnpm install`).

1. In Raygun, bump the version in `extensions/<name>/raygun-extension.json` of every extension that changed, then pack every extension in `extensions/` (new ones need nothing else):

   ```bash
   pnpm repo:publish
   ```

   Commit `repo/` and push Raygun.

2. For a changed community source, bump the version in `raygun/sources/<name>/raygun-extension.json`, then pack them all from this folder:

   ```bash
   node ../raygun/packages/sdk/bin/raygun-ext.mjs pack-all raygun/sources --repo raygun
   ```

3. For a changed novel script, bump `ver` in its first line (Shosetsu's metadata comment).

4. Write the indexes:

   ```bash
   python tools/build_index.py
   ```

   The build stops when an extension in Raygun's `extensions/` or in `raygun/sources/` isn't packed at its current version, or when a package doesn't match its index entry. Pass `--raygun <path>` for a checkout elsewhere; `--allow-unpublished` lists what is already published instead of stopping.

5. Commit and push.

A published package never changes: installs check its SHA-256. Changed code needs a new version; without one, packing keeps the published copy and says so.

## Checking

The whole index, installed and loaded the way Raygun does it (from a Raygun checkout):

```bash
PARALINE_INDEX=/path/to/paraline-raygun/index.json cargo test -p raygun-ext-host -- --ignored paraline_live --nocapture
```

A novel source from listing to chapter text:

```bash
SHOSETSU_DIR=/path/to/paraline-raygun/shosetsu cargo test -p raygun-ext-host -- --ignored shosetsu_survey --nocapture
```

## Licence

Openverse audio is MIT. The scripts are adapted from [shosetsuorg/extensions](https://gitlab.com/shosetsuorg/extensions) and stay under the GNU GPL v3 (`LICENSE`); each names its source in its header. The libraries in `shosetsu/lib/` (and their copies in `lib/`) are unchanged from the official repository: `dkjson` keeps its own MIT licence, stated in the file, and `url` comes from the same repository. Raygun's extensions are published under their own licences in Raygun's repository.
