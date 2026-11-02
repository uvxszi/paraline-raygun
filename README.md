# Paraline Raygun

Sources and add-ons for [Raygun](https://github.com/uvxszi/raygun), kept working.

When a source that works in its own app breaks in Raygun because the site changed, the fixed copy lands here. Each one keeps its original id, so a fixed script installs as an update over the broken copy. Your library and reading progress stay as they are.

Only sources for legitimate sites go here: free web-novel platforms, writing communities and public-domain libraries. No scrapers of unlicensed copies, and nothing that gets around a site's bot checks.

## Add it

| What | Add this address |
| --- | --- |
| Novel sources (Shosetsu scripts) | `https://raw.githubusercontent.com/uvxszi/paraline-raygun/main/shosetsu/index.json` |

In Raygun, open Browse → Extensions → Repositories → Add. The novel sources repository also works in [Shosetsu](https://shosetsu.app) itself.

## What's here

### Novel sources (`shosetsu/`)

| Source | Version | What was fixed |
| --- | --- | --- |
| Syosetsu (ja) | 2.2.6 | Search and rankings read the desktop layout as well as the phone one. Chapters use the current title markup, and the text includes the foreword and afterword (the old script returned only the foreword when there was one). |
| Wattpad (en) | 1.0.8 | Stories and chapters come from Wattpad's JSON and text endpoints, not its pages, whose generated class names change with every Wattpad release. Long parts arrive whole. |

Libraries (`shosetsu/lib/`) are unchanged copies from the official repository: `dkjson` (MIT, David Kolf) and `url`.

## Working on it

- Each script's first line is Shosetsu's metadata comment. Bump `ver` with every change.
- Run `python tools/build_index.py` to rewrite `shosetsu/index.json` (SHA-256 hashes, versions).
- Check a script in Raygun with its survey test, pointed at this folder:

  ```bash
  SHOSETSU_DIR=/path/to/paraline-raygun/shosetsu cargo test -p raygun-ext-host -- --ignored shosetsu_survey --nocapture
  ```

## Licence

The scripts are adapted from [shosetsuorg/extensions](https://gitlab.com/shosetsuorg/extensions) and stay under the GNU GPL v3 (`LICENSE`). Each one names its source in its header. `dkjson` keeps its own MIT licence, stated in the file.
