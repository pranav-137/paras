require 'googleauth'
require 'google/apis/gmail_v1'
require 'googleauth/stores/file_token_store'  # 👈 THIS LINE IS MANDATORY

if Rails.env.development? || Rails.env.production?
  secret_file = Rails.root.join('client_secret.json')
  if File.exist?(secret_file)
    GOOGLE_CLIENT_ID = Google::Auth::ClientId.from_file(secret_file)
    GOOGLE_TOKEN_STORE = Google::Auth::Stores::FileTokenStore.new(file: 'tokens.yaml')
    GMAIL_SCOPE = 'https://www.googleapis.com/auth/gmail.send'
    GOOGLE_AUTHORIZER = Google::Auth::UserAuthorizer.new(GOOGLE_CLIENT_ID, GMAIL_SCOPE, GOOGLE_TOKEN_STORE)
  else
    Rails.logger.warn("⚠️ Google client_secret.json missing, skipping Google Auth setup.")
  end
end
