# Validate presence of critical environment variables
# Fail fast in production; warn in development/test.

required = %w[TMDB_API_KEY STRIPE_SECRET_KEY]
missing = required.select { |k| ENV[k].to_s.strip.empty? }

if missing.any?
  if Rails.env.production?
    raise "Missing required env vars: #{missing.join(', ')}"
  else
    Rails.logger.warn("Missing env vars: #{missing.join(', ')}")
  end
end
