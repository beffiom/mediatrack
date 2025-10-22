require "json"

module Tmdb
  class Client
    BASE_URL = "https://api.themoviedb.org/3"

    def initialize(api_key: ENV["TMDB_API_KEY"])
      @api_key = api_key
      @conn = Faraday.new(url: BASE_URL) do |f|
        f.request :url_encoded
        f.adapter Faraday.default_adapter
      end
    end

    # Returns true if the API key successfully accesses the configuration endpoint
    def valid_key?
      begin
        get("/configuration")
        true
      rescue
        false
      end
    end

    def search_multi(query, media_type: nil)
      # Use multi search then filter into movie/tv, with crude anime handling
      resp = get("/search/multi", query: query)
      results = resp.fetch("results", [])
      results = results.select { |r| %w[movie tv].include?(r["media_type"]) }
      if media_type.present?
        if media_type == "anime"
          # Treat anime as tv with animation genre (16) or origin JP
          results = results.select { |r| r["media_type"] == "tv" }
          # We can't filter genres reliably from multi results; leave to user
        else
          results = results.select { |r| r["media_type"] == media_type }
        end
      end
      results.map { |r| normalize_result(r) }
    end

    private

    def get(path, params = {})
      raise "Missing TMDB_API_KEY" if @api_key.to_s.strip.empty?
      res = @conn.get(path, params.merge(api_key: @api_key))
      if res.status >= 400
        raise "TMDB error #{res.status}: #{res.body}"
      end
      JSON.parse(res.body)
    end

    def normalize_result(r)
      if r["media_type"] == "movie"
        title = r["title"]
        date = r["release_date"]
      else
        title = r["name"]
        date = r["first_air_date"]
      end
      {
        tmdb_id: r["id"],
        title: title,
        media_type: r["media_type"],
        overview: r["overview"],
        poster_path: r["poster_path"],
        release_date: date
      }
    end
  end
end
