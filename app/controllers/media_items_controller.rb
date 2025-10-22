class MediaItemsController < ApplicationController
  def index
  end

  def show
    @media_item = MediaItem.find(params[:id])
  end

  def search
    query = params[:q].to_s.strip
    @results = []
    if query.present?
      client = Tmdb::Client.new
      @results = client.search_multi(query, media_type: params[:media_type])
    end
  end
end
