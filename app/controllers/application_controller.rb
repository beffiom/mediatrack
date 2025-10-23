class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    movies_path
  end

  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from 'Tmdb::Error', with: :handle_tmdb_error
  rescue_from Stripe::StripeError, with: :handle_stripe_error

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :tmdb_api_key])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :tmdb_api_key])
  end

  private

  def handle_record_invalid(e)
    redirect_back fallback_location: root_path, alert: e.record.errors.full_messages.to_sentence
  end

  def handle_tmdb_error(e)
    msg = case e
          when Tmdb::MissingKey then "missing tmdb api key"
          when Tmdb::HttpError then (e.status == 401 ? "invalid tmdb api key" : "tmdb error, please try again")
          else "tmdb error"
          end
    redirect_back fallback_location: root_path, alert: msg
  end

  def handle_stripe_error(e)
    redirect_back fallback_location: root_path, alert: "stripe error: #{e.message}"
  end
end
