# mediatrack
ruby on rails application to track movies, tv, and anime via tmdb with stripe-backed subscriptions.

## setup
- requirements: ruby, bundler, postgres (dev), flyctl (deploy)
- install gems: `bundle install`
- database: ensure postgres is running, then `bin/rails db:create db:migrate`

## environment variables
set these in development via `.env` (dotenv-rails loads it) and in production via fly secrets.
- TMDB_API_KEY
- STRIPE_SECRET_KEY
- STRIPE_PRICE_ID
- STRIPE_WEBHOOK_SECRET (optional in dev)

never commit secrets. `.gitignore` excludes: `config/master.key`, `.env*`, `config/credentials/*.key`, `vendor/bundle/`, `.fly/`.

## deploy (fly.io)
- create app: `flyctl apps create <app-name>`
- set secrets:
  - `RAILS_MASTER_KEY={{RAILS_MASTER_KEY}}`
  - `TMDB_API_KEY={{TMDB_API_KEY}}`
  - `STRIPE_SECRET_KEY={{STRIPE_SECRET_KEY}}`
  - `STRIPE_PRICE_ID={{STRIPE_PRICE_ID}}`
  - `STRIPE_WEBHOOK_SECRET={{STRIPE_WEBHOOK_SECRET}}`
- deploy: `flyctl deploy`
