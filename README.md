# Paraline

A repository of public-domain and openly licensed content for [Raygun](https://github.com/uvxszi/raygun): Raygun's own sources and community sources, in one index. Every source names the licence of what it serves.

## Adding it

New installs of Raygun start with Paraline. To add it again, open Browse → Extensions → Repositories and add Paraline from the suggestions, or add this address:

```
https://raw.githubusercontent.com/uvxszi/paraline-raygun/main/index.json
```

Raygun 1.0.0 used two separate addresses, which stay published: `raygun/index.json` (the community sources) and `shosetsu/index.json` (now an empty index). Newer versions of Raygun replace them with Paraline.

## Rules for sources

- The works are in the public domain, or under a licence that allows redistribution: a Creative Commons licence, CC0, the GNU Free Documentation License or a public-domain mark. The Live Music Archive's shows come from artists who allow free, non-commercial sharing of them; shows an artist keeps to streaming only are left out.
- Each source's description names that licence, and each title's details name its own.
- Podcast directories only name feeds that their publishers make public for any podcast app. Raygun reads each feed itself; every podcast keeps its own terms.
- Music data sources (MusicBrainz, ListenBrainz, Last.fm) give details, charts, tags and recommendations, not recordings. Last.fm's data follows its API terms: non-commercial use, credited to Last.fm, without Last.fm's pictures.
- Some sources need a key of your own: Podcast Index, Last.fm, Europeana, the National Archives and the National Park Service. Their terms keep keys personal, so you enter yours in the source's settings; Raygun asks such a source nothing until it has one.
- Each source reads the official API or feed of the site or archive that publishes the works (its own pages where it has none), and keeps within its published request limits.
- No source gets around bot checks, sign-ins or paywalls.
- Where uploaders set their own licences, a source keeps to the collections and dates whose status holds up, rather than taking every upload's word for it. Archives' items are listed only when their own records say they're free to use (the Library of Congress: no known restrictions, and old enough to be in the public domain; the National Archives: unrestricted; the National Park Service: made by the park service or another federal agency; Europeana: open reuse; the Internet Archive's books: scanned with libraries, marked not in copyright and published more than 95 years ago, and not lent; the Great 78 Project's records: recorded more than 101 years ago, so published more than 100 years ago, and issued; UC Santa Barbara's cylinders: released more than 100 years ago and issued. Recordings never issued, such as home and field recordings, stay protected in the United States until 2067).
- PeerTube videos are listed only when their uploader published them under a Creative Commons licence or CC0, and each video's instance is asked again when it opens. Live streams are left out.
- ESA/Hubble's, ESA/Webb's, ESO's and NOIRLab's videos are CC BY 4.0; their soundtracks are licensed separately and play as published. NASA's Scientific Visualization Studio videos whose page names licensed music are left out, since that music isn't in the public domain.

## Contents

| Source                               | Licence                                        | What it gives                                                                                                        |
| ------------------------------------ | ---------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| Project Gutenberg                    | Public domain                                  | Books, split into chapters                                                                                           |
| Standard Ebooks                      | Public domain (CC0)                            | Edited editions of classic books, chapter by chapter                                                                 |
| Wikisource                           | Public domain, Creative Commons                | Novels, stories, poems and plays proofread by volunteers                                                             |
| OpenStax                             | CC BY 4.0, CC BY-NC-SA 4.0                     | Peer-reviewed college textbooks, section by section                                                                  |
| Wikibooks                            | CC BY-SA 4.0                                   | Open textbooks and manuals written by volunteers                                                                     |
| BCcampus OpenEd                      | Creative Commons, public domain                | Open textbooks from British Columbia's colleges and universities                                                     |
| Saylor Academy                       | CC BY-NC-SA 3.0                                | Open textbooks in business, economics, IT and more                                                                   |
| Green Tea Press                      | CC BY, CC BY-NC, CC BY-NC-SA                   | Allen Downey's Think books on Python, statistics, Bayes and more                                                     |
| GNU manuals                          | GNU FDL and other free licences                | Manuals of the GNU project's software                                                                                |
| LibriVox                             | Public domain                                  | Audiobooks read by volunteers                                                                                        |
| Loyal Books                          | Public domain                                  | Audiobooks                                                                                                           |
| Gutenberg open audiobooks            | Public domain (Project Gutenberg License)      | Project Gutenberg's books read by neural voices                                                                      |
| Internet Archive                     | Public domain, Creative Commons                | Netlabel, Musopen and Free Music Archive recordings; public-domain films; MIT OpenCourseWare lectures                |
| Internet Archive books               | Public domain                                  | Books published more than 95 years ago, scanned with libraries, read as PDFs                                         |
| Internet Archive comics              | Public domain                                  | Comics published more than 95 years ago                                                                              |
| Wikimedia Commons                    | Public domain, Creative Commons                | Recordings and videos, with subtitles                                                                                |
| Library of Congress                  | Public domain                                  | Films published before 1931 and recordings before 1926, from Edison on                                               |
| Great 78 Project                     | Public domain                                  | 78 rpm records recorded more than 101 years ago, with charts by decade and genre                                     |
| UCSB Cylinder Audio Archive          | Public domain; transfers CC BY-NC 2.5          | Cylinder records released more than 100 years ago, from the 1890s on                                                 |
| National Archives                    | Public domain (US government)                  | US government films free of use restrictions (with your own API key)                                                 |
| National Park Service                | Public domain (US government)                  | Films of the national parks, with captions (with your own free API key)                                              |
| Europeana                            | Public domain, CC0, CC BY, CC BY-SA            | Films and recordings from Europe's archives open to reuse (with your own free API key)                               |
| NASA Image and Video Library         | Public domain (NASA media)                     | NASA's videos, with captions                                                                                         |
| NASA Scientific Visualization Studio | Public domain (NASA media)                     | Visualizations and animations of Earth, the Sun, the planets and the universe, with captions                         |
| ESA/Hubble and ESA/Webb              | CC BY 4.0                                      | The Hubble and Webb space telescopes' videos                                                                         |
| ESO and NOIRLab                      | CC BY 4.0                                      | The European Southern Observatory's and NSF NOIRLab's videos                                                         |
| Blender open movies                  | CC BY, CC BY-SA                                | Blender Studio's open movies                                                                                         |
| PeerTube                             | Creative Commons, CC0                          | Videos from PeerTube's instances, found through Sepia Search, with captions and comments                             |
| Pepper&Carrot                        | CC BY 4.0                                      | David Revoy's webcomic                                                                                               |
| xkcd                                 | CC BY-NC 2.5                                   | Randall Munroe's webcomic                                                                                            |
| Open webcomics                       | CC BY-NC-ND 3.0, CC BY-NC-SA 4.0, CC BY-SA 4.0 | Sandra and Woo by Oliver Knörzer and Powree, Daniel Stori's turnoff.us and David Revoy's MiniFantasyTheater          |
| MusicBrainz                          | CC0, CC BY-SA (metadata)                       | Song, album and artist details, genres, credits and cover art from the Cover Art Archive                             |
| ListenBrainz                         | CC0 (statistics)                               | The most listened-to songs, genre radios, similar artists and songs, and artists' new releases                       |
| Last.fm                              | Last.fm API terms (non-commercial)             | Charts by country and genre, song tags, similar artists and songs, artists' biographies (with your own free API key) |
| Incompetech                          | CC BY 4.0                                      | Kevin MacLeod's music, with his collections as albums and charts by genre and mood                                   |
| Live Music Archive                   | Free non-commercial sharing (artists')         | Concert recordings by trade-friendly artists, with whole concerts as albums                                          |
| fyyd podcasts                        | Directory of public feeds                      | Podcasts to find and follow, and the most active ones in a language                                                  |
| Podcast Index                        | Directory of public feeds                      | Podcasts to find and follow, and what's trending (with your own free API key)                                        |
| Openverse audio                      | Creative Commons, CC0, Public Domain Mark      | Songs from Jamendo, Freesound, Wikimedia Commons and more                                                            |

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
