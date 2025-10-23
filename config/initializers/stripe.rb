# Stripe configuration
# Reads secret key from environment variables provided by Fly.io (or .env in development)
# Never hardcode secrets here.

if ENV["STRIPE_SECRET_KEY"].present?
  Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
else
  # Skip validation during asset precompilation
  unless ENV['SECRET_KEY_BASE_DUMMY']
    if Rails.env.production?
      raise "ENV['STRIPE_SECRET_KEY'] is required in production"
    else
      Rails.logger.warn("STRIPE_SECRET_KEY is not set; Stripe API calls will fail")
    end
  end
end
