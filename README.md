# MediaTrack

A Ruby on Rails 8.1 application for tracking movies, TV shows, and anime with TMDB integration and Stripe-backed subscriptions.

## Features

- **User Authentication**: Username-based authentication via Devise with optional email
- **Media Tracking**: Browse and search movies, TV shows, and anime via TMDB API
- **Personal Watchlist**: Track media with status (planned/watching/completed) and watched dates
- **Anime Detection**: Automatic identification of anime (TV shows with animation genre from Japan)
- **Subscription Management**: Stripe integration for premium subscriptions
- **User Settings**: Update password and manage personal TMDB API keys
- **Caching**: Rails cache for media items and search results to reduce API calls

## Technology Stack

### Backend
- **Rails**: 8.1.0 (latest)
- **Ruby**: 3.4.7
- **Database**: PostgreSQL
- **Web Server**: Puma with Thruster
- **Authentication**: Devise
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache
- **Action Cable**: Solid Cable

### Frontend
- **Asset Pipeline**: Propshaft
- **JavaScript**: Import maps with Turbo and Stimulus (Hotwire)
- **Styling**: Custom CSS

### APIs & Services
- **TMDB**: Movie/TV data via Faraday HTTP client
- **Stripe**: Payment processing and webhook handling
- **Image Processing**: libvips for Active Storage variants

### Development Tools
- **Testing**: Minitest with Capybara and Selenium for system tests
- **Code Quality**: RuboCop (Rails Omakase), Brakeman, bundler-audit
- **Environment Variables**: dotenv-rails
- **Deployment**: Fly.io


## Database Schema

### users
- Username-based authentication (email optional)
- Stripe integration: `stripe_customer_id`, `subscription_status`
- Optional personal `tmdb_api_key` (validated on save)

### media_items
- TMDB data: `tmdb_id` (unique), `title`, `media_type` (movie/tv/anime)
- Metadata: `overview`, `poster_path`, `release_date`

### watchlist_items
- Links users to media items
- `status`: planned, watching, or completed
- `watched_on`: completion date
- Unique constraint per user+media_item

## Setup

### Requirements
- Ruby 3.4.7
- Bundler
- PostgreSQL
- Fly.io CLI (for deployment)

### Installation

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Setup database:
   ```bash
   bin/rails db:create db:migrate
   ```

3. Create `.env` file with required variables (see below)

### Environment Variables

Development: Create `.env` file in project root (loaded by dotenv-rails):

```env
TMDB_API_KEY=your_tmdb_api_key
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PRICE_ID=price_...
STRIPE_WEBHOOK_SECRET=whsec_...  # Optional in development
```

Production: Set via Fly.io secrets (see deployment section)

## Development

### Running the Server
```bash
bin/rails server
```

Visit http://localhost:3000

### Running Tests
```bash
# All tests
bin/rails test

# System tests (browser automation)
bin/rails test:system

# Specific test file
bin/rails test test/models/user_test.rb
```

### Code Quality
```bash
# Lint code style
bin/rubocop

# Security scan
bin/brakeman

# Audit gem vulnerabilities
bin/bundler-audit

# JavaScript dependency audit
bin/importmap audit
```

## Testing

The application uses Minitest with comprehensive test coverage:

- **Unit Tests**: Model validations, associations, and business logic
- **Controller Tests**: Request/response handling and error conditions
- **System Tests**: End-to-end user flows with browser automation (Capybara + Selenium)

### CI Pipeline

GitHub Actions runs on every push to master and pull requests:
- Security scanning (Brakeman, bundler-audit, importmap audit)
- Linting (RuboCop)
- Unit and controller tests
- System tests with screenshot capture on failure

## Deployment

### Fly.io

The application is configured for Fly.io deployment with:
- **Region**: Dallas (dfw)
- **Port**: 3000 (internal)
- **HTTPS**: Forced, auto-managed
- **Auto-scaling**: Stops machines when idle, auto-starts on traffic
- **Database**: PostgreSQL via Fly.io managed service (configure separately)

#### Initial Setup

1. Create Fly.io app:
   ```bash
   flyctl apps create mediatrack
   ```

2. Create PostgreSQL database:
   ```bash
   flyctl postgres create
   flyctl postgres attach --app mediatrack
   ```

3. Set secrets:
   ```bash
   flyctl secrets set RAILS_MASTER_KEY={{RAILS_MASTER_KEY}}
   flyctl secrets set TMDB_API_KEY={{TMDB_API_KEY}}
   flyctl secrets set STRIPE_SECRET_KEY={{STRIPE_SECRET_KEY}}
   flyctl secrets set STRIPE_PRICE_ID={{STRIPE_PRICE_ID}}
   flyctl secrets set STRIPE_WEBHOOK_SECRET={{STRIPE_WEBHOOK_SECRET}}
   ```

4. Deploy:
   ```bash
   flyctl deploy
   ```

#### Subsequent Deploys
```bash
flyctl deploy
```

#### Check Status
```bash
flyctl status
flyctl logs
```

### Docker

The application includes a production-ready Dockerfile:

```bash
# Build
docker build -t mediatrack .

# Run
docker run -d -p 3000:3000 \
  -e RAILS_MASTER_KEY={{RAILS_MASTER_KEY}} \
  -e DATABASE_URL={{DATABASE_URL}} \
  -e TMDB_API_KEY={{TMDB_API_KEY}} \
  -e STRIPE_SECRET_KEY={{STRIPE_SECRET_KEY}} \
  -e STRIPE_PRICE_ID={{STRIPE_PRICE_ID}} \
  --name mediatrack mediatrack
```

## API Integration

### TMDB

The application uses TMDB API v3 for media data:
- Multi-search endpoint with automatic anime detection
- Caching layer to minimize API calls (1 hour TTL)
- Per-user API key support for personalized rate limits
- Automatic key validation on user settings update

### Stripe

- Checkout session creation for subscriptions
- Webhook handling for subscription lifecycle events
- Customer portal integration for subscription management
- Webhook signature verification for security
