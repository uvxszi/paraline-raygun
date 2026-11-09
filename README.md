# Paraline

A repository of public-domain and openly licensed content for [Raygun](https://github.com/uvxszi/raygun): Raygun's own sources and community sources, in one index. Every source names the licence of what it serves.

## Adding it

New installs of Raygun start with Paraline. To add it again, open Browse → Extensions → Repositories and add Paraline from the suggestions, or add this address:

```
https://raw.githubusercontent.com/uvxszi/paraline-raygun/main/index.json
```

Raygun 1.0.0 used two separate addresses, which stay published: `raygun/index.json` (the community sources) and `shosetsu/index.json` (now an empty index). Newer versions of Raygun replace them with Paraline.

## Rules for sources

- The works are in the public domain, or under a licence that allows redistribution: a Creative Commons licence, CC0 or a public-domain mark.
- Each source's description names that licence.
- Each source reads the official API or feed of the site or archive that publishes the works.
- No source gets around bot checks, sign-ins or paywalls.
- Where uploaders set their own licences, a source keeps to the collections and dates whose status holds up, rather than taking every upload's word for it.

## Contents

| Source                       | Licence                                   | What it gives                                                                            |
| ---------------------------- | ----------------------------------------- | ---------------------------------------------------------------------------------------- |
| Project Gutenberg            | Public domain                             | Books, split into chapters                                                               |
| Standard Ebooks              | Public domain (CC0)                       | Edited editions of classic books, chapter by chapter                                     |
| Wikisource                   | Public domain, Creative Commons           | Novels, stories, poems and plays proofread by volunteers                                 |
| LibriVox                     | Public domain                             | Audiobooks read by volunteers                                                            |
| Loyal Books                  | Public domain                             | Audiobooks                                                                               |
| Internet Archive             | Public domain, Creative Commons           | Netlabel and Musopen recordings; public-domain films                                     |
| Internet Archive comics      | Public domain                             | Comics published more than 95 years ago                                                  |
| Wikimedia Commons            | Public domain, Creative Commons           | Recordings and videos, with subtitles                                                    |
| NASA Image and Video Library | Public domain (NASA media)                | NASA's videos, with captions                                                             |
| Blender open movies          | CC BY, CC BY-SA                           | Blender Studio's open movies                                                             |
| Pepper&Carrot                | CC BY 4.0                                 | David Revoy's webcomic                                                                   |
| xkcd                         | CC BY-NC 2.5                              | Randall Munroe's webcomic                                                                |
| MusicBrainz                  | CC0, CC BY-SA (metadata)                  | Song, album and artist details, genres, credits and cover art from the Cover Art Archive |
| ListenBrainz charts          | CC0 (statistics)                          | The songs most listened to on ListenBrainz this week, month, year and of all time        |
| Openverse audio              | Creative Commons, CC0, Public Domain Mark | Songs from Jamendo, Freesound, Wikimedia Commons and more                                |

Raygun's own sources are listed by their address in Raygun's repository (`repo/` in `uvxszi/raygun`). Openverse audio is a community source kept here, in `raygun/`.

## Stremio addons

Paraline also lists Stremio's own official addons, which Raygun 1.3.0 offers as sources to add (`stremio/addons.json`, under `addons` in the index; earlier versions of Raygun skip them). Paraline hosts nothing of theirs: each is run by Stremio, and what it gives follows that service's own terms.

| Addon            | What it gives                                                                |
| ---------------- | ---------------------------------------------------------------------------- |
| OpenSubtitles v3 | Subtitles for films and series, from OpenSubtitles.org (its uploaders' work) |
| Cinemeta         | Details of films and series, with IMDb ratings                               |
| WatchHub         | Where a title streams legally                                                |

[`stremio/addons.md`](stremio/addons.md) lists these and other legal Stremio addons by address.

## Later

Paraline may later host remastered, colourized or upscaled versions of public-domain works, published under an open licence.

## Layout

| Path                                    | What                                                               | Written by              |
| --------------------------------------- | ------------------------------------------------------------------ | ----------------------- |
| `index.json`                            | Paraline's index, in Raygun's format                               | `tools/build_index.py`  |
| `raygun/sources/<name>/`                | A community source: `raygun-extension.json`, `src/`, built `dist/` | hand, then `raygun-ext` |
| `raygun/packages/`, `raygun/index.json` | The community sources' packages and index                          | `raygun-ext pack-all`   |
| `shosetsu/index.json`                   | An empty index at the address Raygun 1.0.0 added                   | `tools/build_index.py`  |
| `stremio/addons.json`                   | The Stremio addons the index lists                                 | hand                    |
| `stremio/addons.md`                     | Stremio addon addresses                                            | hand                    |

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

3. Write the indexes:

   ```bash
   python -I tools/build_index.py
   ```

   The build stops when an extension in Raygun's `extensions/` or in `raygun/sources/` isn't packed at its current version, or when a package doesn't match its index entry. Pass `--raygun <path>` for a checkout elsewhere; `--allow-unpublished` lists what is already published instead of stopping.

4. Commit and push.

A published package never changes: installs check its SHA-256. Changed code needs a new version; without one, packing keeps the published copy and says so.

## Checking

The whole index, installed and loaded the way Raygun does it (from a Raygun checkout):

```bash
PARALINE_INDEX=/path/to/paraline-raygun/index.json cargo test -p raygun-ext-host -- --ignored paraline_live --nocapture
```

## Licence

Paraline's tools are under the GNU GPL v3 (`LICENSE`). Openverse audio is MIT, as its header states. Raygun's extensions are published under their own licences in Raygun's repository. The works each source serves keep their own licences, named above and in each source's description.
