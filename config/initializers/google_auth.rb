require 'googleauth'
require 'google/apis/gmail_v1'
require 'googleauth/stores/file_token_store'  # 👈 THIS LINE IS MANDATORY

GMAIL_SCOPE = 'https://www.googleapis.com/auth/gmail.send'
GOOGLE_CLIENT_ID = Google::Auth::ClientId.from_file(Rails.root.join('client_secret.json'))
TOKEN_STORE = Google::Auth::Stores::FileTokenStore.new(file: Rails.root.join('token.yaml'))
GOOGLE_AUTHORIZER = Google::Auth::UserAuthorizer.new(GOOGLE_CLIENT_ID, GMAIL_SCOPE, TOKEN_STORE)
