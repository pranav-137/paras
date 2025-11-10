require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings.
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Store uploaded files on the local file system.
  config.active_storage.service = :local

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

  # Force all access to the app over SSL.
  config.force_ssl = true

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)

  # Change to "debug" to log everything (including personally identifiable info!)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  # Don’t log any deprecations.
  config.active_support.report_deprecations = false

  # Use durable caching and background jobs.
  config.cache_store = :solid_cache_store
  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue } }

  # Action Mailer — URLs and host setup for production.
  config.action_mailer.default_url_options = {
    host: "paras-production.up.railway.app",
    protocol: "https"
  }

  # Ensure mailer assets (images, CSS, etc.) load correctly.
  config.action_mailer.asset_host = "https://paras-production.up.railway.app"

  # Allow your production host (Railway custom domain)
  config.hosts = ["paras-production.up.railway.app"]

  # Enable locale fallbacks for I18n (use default locale when missing translations).
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Optimize ActiveRecord inspection output.
  config.active_record.attributes_for_inspect = [:id]
end
