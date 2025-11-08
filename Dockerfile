# syntax=docker/dockerfile:1
# check=error=true

# Production Dockerfile for Rails

ARG RUBY_VERSION=3.2.3
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Throw-away build stage to reduce final image size
FROM base AS build

# Install build dependencies for gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy app code
COPY . .

# Precompile bootsnap cache (safe)
RUN bundle exec bootsnap precompile app/ lib/

# (Optional) Create dummy client_secret.json to prevent GoogleAuth crash
RUN echo '{"installed":{"client_id":"dummy","project_id":"dummy","auth_uri":"dummy","token_uri":"dummy","client_secret":"dummy"}}' > client_secret.json

# ⚠️ SKIP asset precompile during build — do it at runtime instead
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final runtime image
FROM base

# Copy built gems and app
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Create non-root user for security
# RUN groupadd --system --gid 1000 rails && \
#     useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
#     chown -R rails:rails db log storage tmp
# USER 1000:1000
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p /rails/public/assets && \
    chown -R rails:rails db log storage tmp public
USER 1000:1000

# Entrypoint prepares DB
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose port
EXPOSE 80

# Start server — precompile assets at runtime (when Railway vars exist)
# CMD ["bash", "-c", "bundle exec rails assets:precompile && bundle exec rails db:migrate && bundle exec rails server -b 0.0.0.0 -p 80"]
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile
CMD ["bash", "-c", "bundle exec rails assets:precompile && bundle exec rails db:migrate && bundle exec rails server -b 0.0.0.0 -p 80"]
