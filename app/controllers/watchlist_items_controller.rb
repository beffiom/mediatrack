class WatchlistItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    media = find_or_create_media_item
    item = current_user.watchlist_items.build(media_item: media, status: safe_params[:status] || "planned", watched_on: safe_params[:watched_on])
    if item.save
      redirect_back fallback_location: media_items_path, notice: "added to your watchlist"
    else
      redirect_back fallback_location: media_items_path, alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    item = current_user.watchlist_items.find(params[:id])
    if item.update(safe_params)
      redirect_back fallback_location: media_items_path, notice: "updated watchlist item"
    else
      redirect_back fallback_location: media_items_path, alert: item.errors.full_messages.to_sentence
    end
  end

  def destroy
    item = current_user.watchlist_items.find(params[:id])
    if item.destroy
      redirect_back fallback_location: media_items_path, notice: "removed from watchlist"
    else
      redirect_back fallback_location: media_items_path, alert: "could not remove item"
    end
  end

  private

  def safe_params
    params.permit(:status, :watched_on, :media_item_id, :tmdb_id, :title, :media_type, :poster_path, :release_date)
  end

  def find_or_create_media_item
    if safe_params[:media_item_id].present?
      MediaItem.find(safe_params[:media_item_id])
    else
      media = MediaItem.find_or_initialize_by(tmdb_id: safe_params[:tmdb_id].to_i)
      media.title ||= safe_params[:title]
      media.media_type ||= safe_params[:media_type]
      media.poster_path ||= safe_params[:poster_path]
      media.release_date ||= safe_params[:release_date]
      media.save!
      media
    end
  end
end
