# syntax=docker/dockerfile:1
# check=error=true

# 🚀 Production Dockerfile for Ruby on Rails (Optimized for Railway)

ARG RUBY_VERSION=3.2.3
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Set working directory
WORKDIR /rails

# Install essential runtime packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set environment variables for production
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# ---------- BUILD STAGE ----------
FROM base AS build

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy gem files and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy the rest of the app
COPY . .

# Precompile bootsnap cache for faster boot
RUN bundle exec bootsnap precompile app/ lib/

# Create dummy Google client_secret.json to avoid errors in build phase
RUN echo '{"installed":{"client_id":"dummy","project_id":"dummy","auth_uri":"dummy","token_uri":"dummy","client_secret":"dummy"}}' > client_secret.json

# ⚙️ Precompile assets using a dummy DATABASE_URL so Rails doesn’t fail
RUN SECRET_KEY_BASE_DUMMY=1 DATABASE_URL=postgresql://dummy/dummy ./bin/rails assets:precompile

# ---------- RUNTIME STAGE ----------
FROM base

# Copy built gems and Rails app from build stage
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Create a non-root Rails user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p /rails/public/assets && \
    chown -R rails:rails db log storage tmp public
USER 1000:1000

# Entrypoint script to prepare DB/migrations if needed
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose web port (Railway maps this automatically)
EXPOSE 80

# Start the Rails server — ensures assets and migrations are ready
CMD ["bash", "-c", "bundle exec rails db:migrate && bundle exec rails server -b 0.0.0.0 -p 80"]
