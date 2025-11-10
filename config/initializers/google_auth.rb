# config/initializers/google_auth.rb
require "googleauth"
require "google/apis/gmail_v1"
require "googleauth/stores/file_token_store"

Rails.logger.info "✅ Loading Google Auth Initializer..."

begin
  # Use /tmp for Railway since it's writable even in production
  secret_path = "/tmp/client_secret.json"

  # Create client_secret.json from ENV if present
  if ENV["GOOGLE_CLIENT_SECRET_JSON"].present?
    File.write(secret_path, ENV["GOOGLE_CLIENT_SECRET_JSON"])
    Rails.logger.info "📦 Created client_secret.json from ENV variable in /tmp"
  end

  if File.exist?(secret_path)
    Rails.logger.info "🔑 Found client_secret.json — initializing Google Auth..."

    # Initialize Google OAuth client
    GOOGLE_CLIENT_ID = Google::Auth::ClientId.from_file(secret_path)

    # Use a token file path — ensure /tmp for production (not read-only)
    token_store_path =
      Rails.env.production? ? "/tmp/tokens.yaml" : Rails.root.join("tokens.yaml")

    GOOGLE_TOKEN_STORE = Google::Auth::Stores::FileTokenStore.new(file: token_store_path)
    GMAIL_SCOPE = "https://www.googleapis.com/auth/gmail.send"

    GOOGLE_AUTHORIZER = Google::Auth::UserAuthorizer.new(
      GOOGLE_CLIENT_ID,
      GMAIL_SCOPE,
      GOOGLE_TOKEN_STORE
    )

    Rails.logger.info "✅ Google Auth initialized successfully."
  else
    Rails.logger.warn("⚠️ client_secret.json missing — initializing dummy Google Auth.")
    GOOGLE_CLIENT_ID = nil
    GOOGLE_TOKEN_STORE = nil
    GMAIL_SCOPE = nil
    GOOGLE_AUTHORIZER = nil
  end

rescue => e
  Rails.logger.error("❌ Google Auth initializer failed: #{e.message}")
  GOOGLE_CLIENT_ID = nil
  GOOGLE_TOKEN_STORE = nil
  GMAIL_SCOPE = nil
  GOOGLE_AUTHORIZER = nil
end
