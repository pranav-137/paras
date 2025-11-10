# syntax=docker/dockerfile:1
# check=error=true

# ---------- BASE STAGE ----------
ARG RUBY_VERSION=3.2.3
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Set working directory
WORKDIR /rails

# Install essential runtime packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Environment setup
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test" \
    RAILS_LOG_TO_STDOUT="true" \
    RAILS_SERVE_STATIC_FILES="true"

# ---------- BUILD STAGE ----------
FROM base AS build

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential git libpq-dev libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy Gem files and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile Ruby bootsnap cache
RUN bundle exec bootsnap precompile app/ lib/

# ✅ Precompile assets safely using a dummy DB (prevents ActiveRecord adapter error)
RUN SECRET_KEY_BASE_DUMMY=1 DATABASE_URL="postgresql://localhost/dummy" ./bin/rails assets:precompile

# ---------- RUNTIME STAGE ----------
FROM base

# Copy built gems and application from build stage
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Create non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p /rails/public/assets && \
    chown -R rails:rails db log storage tmp public

USER 1000:1000

# Entry point
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# ✅ Explicitly expose port 8080 (Railway maps this automatically)
EXPOSE 8080

# ✅ Start Rails using Railway’s dynamic port variable
CMD ["bash", "-c", "bundle exec rails db:migrate && bundle exec rails server -b 0.0.0.0 -p ${PORT:-8080}"]
