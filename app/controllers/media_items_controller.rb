class MediaItemsController < ApplicationController
  def index
  end

  def show
    @media_item = MediaItem.find(params[:id])
  end

  def movies; render_section("movie"); end
  def tv; render_section("tv"); end
  def anime; render_section("anime"); end

  def search
    query = params[:q].to_s.strip
    @results = []
    if query.present?
      begin
        api_key = current_user&.tmdb_api_key.presence || ENV["TMDB_API_KEY"]
        client = Tmdb::Client.new(api_key: api_key)
        @results = client.search_multi(query, media_type: params[:media_type])
      rescue Tmdb::MissingKey
        @api_key_error = current_user&.tmdb_api_key.blank?
        flash.now[:alert] = "missing tmdb api key"
      rescue Tmdb::HttpError => e
        @api_key_error = current_user&.tmdb_api_key.blank? && e.status == 401
        flash.now[:alert] = (e.status == 401 ? "invalid tmdb api key" : "tmdb error, please try again")
      rescue => _e
        flash.now[:alert] = "unexpected error contacting tmdb"
      end
    end
  end

  private

  def render_section(type)
    authenticate_user!
    @media_type = type
    scope = current_user.watchlist_items.includes(:media_item).joins(:media_item).where(media_items: { media_type: type })
    @watched = scope.where(status: "watched")
    @planned = scope.where(status: "planned")
    render :section
  end
end
