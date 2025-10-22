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
      client = Tmdb::Client.new
      @results = client.search_multi(query, media_type: params[:media_type])
    end
  end

  private

  def render_section(type)
    authenticate_user!
    @media_type = type
    scope = current_user.watchlist_items.includes(:media_item).joins(:media_item).where(media_items: { media_type: (type == "anime" ? ["tv","anime"] : type) })
    @watched = scope.where(status: "watched")
    @planned = scope.where(status: "planned")
    render :section
  end
end
