class WatchlistItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    media = find_or_create_media_item
    item = current_user.watchlist_items.create!(media_item: media, status: safe_params[:status] || "planned", watched_on: safe_params[:watched_on])
    redirect_back fallback_location: media_items_path, notice: "Added to your watchlist"
  end

  def update
    item = current_user.watchlist_items.find(params[:id])
    item.update!(safe_params)
    redirect_back fallback_location: media_items_path, notice: "Updated watchlist item"
  end

  def destroy
    item = current_user.watchlist_items.find(params[:id])
    item.destroy!
    redirect_back fallback_location: media_items_path, notice: "Removed from watchlist"
  end

  private

  def safe_params
    params.permit(:status, :watched_on, :media_item_id, :tmdb_id, :title, :media_type, :poster_path, :release_date)
  end

  def find_or_create_media_item
    if safe_params[:media_item_id].present?
      MediaItem.find(safe_params[:media_item_id])
    else
      MediaItem.find_or_create_by!(tmdb_id: safe_params[:tmdb_id].to_i) do |m|
        m.title = safe_params[:title]
        m.media_type = safe_params[:media_type]
        m.poster_path = safe_params[:poster_path]
        m.release_date = safe_params[:release_date]
      end
    end
  end
end
