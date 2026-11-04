// Openverse audio — Paraline, MIT.
// Creative Commons and public-domain audio from Openverse's public API: search, and full streams
// from each work's own file (Jamendo, Freesound, Wikimedia Commons…).
/* eslint-disable @typescript-eslint/no-explicit-any */
declare const raygun: any;

var API = "https://api.openverse.org/v1/audio/";
// The most Openverse returns per page without an API key; more is refused with HTTP 401.
var MAX = 20;
// The licences asked for and kept: Creative Commons' licences, CC0 and the Public Domain Mark.
// Openverse also lists works under the retired Sampling licences, which allow less; those stay out.
var LICENCES = ["by", "by-sa", "by-nc", "by-nd", "by-nc-sa", "by-nc-nd", "cc0", "pdm"];

var get = async (query: string, size: number): Promise<any[]> => {
  var url =
    API +
    "?q=" +
    encodeURIComponent(query) +
    "&page_size=" +
    Math.min(MAX, Math.max(1, size)) +
    "&license=" +
    LICENCES.join(",") +
    // Asked of Openverse too, so a page isn't spent on sound effects.
    "&category=music,audiobook" +
    "&mature=false";
  var response = await raygun.http.fetch(url);
  if (!response.ok) throw new Error("Openverse answered HTTP " + response.status);
  var body = await response.json();
  return Array.isArray(body.results) ? body.results : [];
};

// Openly licensed music, not sound effects, and only works with a file to play. The licence is
// checked here too, so a change on Openverse's side can't let other works through.
var playable = (work: any) =>
  work &&
  work.url &&
  LICENCES.indexOf(String(work.license || "").toLowerCase()) >= 0 &&
  (!work.category || work.category === "music" || work.category === "audiobook");

var source = (work: any) => ({ kind: "url", url: work.url, headers: {} });

// Jamendo names its MP3 encodings "mp31" and "mp32".
var format = (filetype: any) =>
  typeof filetype === "string" && filetype ? filetype.replace(/^mp3\d+$/i, "mp3").toUpperCase() : null;

var toTrack = (work: any) => ({
  id: work.id,
  title: work.title || "Untitled",
  artist: work.creator || null,
  album: work.audio_set && work.audio_set.title ? work.audio_set.title : null,
  durationMs: typeof work.duration === "number" ? work.duration : null,
  artworkUrl: work.thumbnail || null,
  source: source(work),
});

raygun.providers.register({
  kind: "music.metadata",
  id: "search",
  name: "Openverse",
  async search(request: any) {
    var query = (request.query || "").trim() || "music";
    var found = await get(query, request.limit * 2);
    return { tracks: found.filter(playable).slice(0, request.limit).map(toTrack) };
  },
});

// Streams for songs found elsewhere, when Openverse has the same work.
raygun.providers.register({
  kind: "music.stream",
  id: "stream",
  name: "Openverse",
  async candidates(request: any) {
    var query = [request.artist, request.title].filter(Boolean).join(" ").trim();
    if (!query) return { candidates: [] };
    var found = await get(query, Math.min(20, request.limit * 2));
    return {
      candidates: found
        .filter(playable)
        .slice(0, request.limit)
        .map((work: any) => ({
          id: work.id,
          title: work.title || "Untitled",
          artist: work.creator || null,
          durationMs: typeof work.duration === "number" ? work.duration : null,
          quality: format(work.filetype),
          bitrateKbps: typeof work.bit_rate === "number" ? Math.round(work.bit_rate / 1000) : null,
          source: source(work),
        })),
    };
  },
});
