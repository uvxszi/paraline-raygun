// community.paraline.openverse 1.0.0. Built by raygun-ext from src/index.ts; do not edit.
(() => {
  // src/index.ts
  var API = "https://api.openverse.org/v1/audio/";
  var MAX = 50;
  var get = async (query, size) => {
    var url = API + "?q=" + encodeURIComponent(query) + "&page_size=" + Math.min(MAX, Math.max(1, size)) + "&mature=false";
    var response = await raygun.http.fetch(url);
    if (!response.ok) throw new Error("Openverse answered HTTP " + response.status);
    var body = await response.json();
    return Array.isArray(body.results) ? body.results : [];
  };
  var playable = (work) => work && work.url && (!work.category || work.category === "music" || work.category === "audiobook");
  var source = (work) => ({ kind: "url", url: work.url, headers: {} });
  var toTrack = (work) => ({
    id: work.id,
    title: work.title || "Untitled",
    artist: work.creator || null,
    album: work.audio_set && work.audio_set.title ? work.audio_set.title : null,
    durationMs: typeof work.duration === "number" ? work.duration : null,
    artworkUrl: work.thumbnail || null,
    source: source(work)
  });
  raygun.providers.register({
    kind: "music.metadata",
    id: "search",
    name: "Openverse",
    async search(request) {
      var query = (request.query || "").trim() || "music";
      var found = await get(query, request.limit * 2);
      return { tracks: found.filter(playable).slice(0, request.limit).map(toTrack) };
    }
  });
  raygun.providers.register({
    kind: "music.stream",
    id: "stream",
    name: "Openverse",
    async candidates(request) {
      var query = [request.artist, request.title].filter(Boolean).join(" ").trim();
      if (!query) return { candidates: [] };
      var found = await get(query, Math.min(20, request.limit * 2));
      return {
        candidates: found.filter(playable).slice(0, request.limit).map((work) => ({
          id: work.id,
          title: work.title || "Untitled",
          artist: work.creator || null,
          durationMs: typeof work.duration === "number" ? work.duration : null,
          quality: work.filetype ? work.filetype.toUpperCase() : null,
          bitrateKbps: typeof work.bit_rate === "number" ? Math.round(work.bit_rate / 1e3) : null,
          source: source(work)
        }))
      };
    }
  });
})();
