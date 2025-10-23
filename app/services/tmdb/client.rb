require "json"

module Tmdb
  class Error < StandardError; end
  class MissingKey < Error; end
  class HttpError < Error
    attr_reader :status, :body
    def initialize(status, body)
      @status = status
      @body = body
      super("TMDB HTTP #{status}")
    end
  end

  class Client
    BASE_URL = "https://api.themoviedb.org/3"

    def initialize(api_key: ENV["TMDB_API_KEY"])
      @api_key = api_key
      @conn = Faraday.new do |f|
        f.options.timeout = 5
        f.options.open_timeout = 2
        f.adapter Faraday.default_adapter
      end
    end

    # Returns true if the API key successfully accesses the configuration endpoint
    def valid_key?
      begin
        get("/configuration")
        true
      rescue Tmdb::Error
        false
      end
    end

    def search_multi(query, media_type: nil)
      # Use multi search then filter into movie/tv, with crude anime handling
      resp = get("/search/multi", query: query)
      results = resp.fetch("results", [])
      results = results.select { |r| %w[movie tv].include?(r["media_type"]) }
      is_anime = false
      if media_type.present?
        if media_type == "anime"
          # Treat anime as tv with animation genre (16) or origin JP
          results = results.select { |r| r["media_type"] == "tv" }
          is_anime = true
          # We can't filter genres reliably from multi results; leave to user
        else
          results = results.select { |r| r["media_type"] == media_type }
        end
      end
      results.map { |r| normalize_result(r, is_anime: is_anime) }
    end

    private

    def get(path, params = {})
      raise Tmdb::MissingKey, "Missing TMDB_API_KEY" if @api_key.to_s.strip.empty?
      query_params = params.merge(api_key: @api_key)
      query_string = URI.encode_www_form(query_params)
      full_url = "#{BASE_URL}#{path}?#{query_string}"
      res = @conn.get(full_url)
      if res.status >= 400
        raise Tmdb::HttpError.new(res.status, res.body)
      end
      JSON.parse(res.body)
    end

    def normalize_result(r, is_anime: false)
      if r["media_type"] == "movie"
        title = r["title"]
        date = r["release_date"]
      else
        title = r["name"]
        date = r["first_air_date"]
      end
      
      # Auto-detect anime: TV shows with Animation genre (16) from Japan
      if r["media_type"] == "tv" && !is_anime
        genre_ids = r["genre_ids"] || []
        origin_countries = r["origin_country"] || []
        is_anime = genre_ids.include?(16) && origin_countries.include?("JP")
      end
      
      {
        tmdb_id: r["id"],
        title: title,
        media_type: is_anime ? "anime" : r["media_type"],
        overview: r["overview"],
        poster_path: r["poster_path"],
        release_date: date
      }
    end
  end
end
