require 'google/apis/gmail_v1'
require 'googleauth'

class CustomDeviseMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  # Confirmation Email
  def confirmation_instructions(record, token, opts = {})
  Rails.logger.info "📨 Sending confirmation email to #{record.email}"

  # Set up variables for the template
  @resource = record
  @token = token

  # ✅ Build the confirmation URL manually
  mapping = Devise.mappings[Devise::Mapping.find_scope!(record)]
  confirmation_link = confirmation_url(mapping.name, confirmation_token: @token)

  html_body = <<~HTML
    <p>Welcome #{record.email}!</p>
    <p>You can confirm your account email through the link below:</p>
    <p><a href="#{confirmation_link}">Confirm my account</a></p>
  HTML

  send_gmail_message(
    to: record.email,
    subject: "Confirm your account",
    html_body: html_body
  )
end


  # Password Reset Email
  def reset_password_instructions(record, token, opts = {})
    send_gmail_message(
      to: record.email,
      subject: "Reset your password",
      html_body: render_to_string(:reset_password_instructions, formats: [:html], locals: { resource: record, token: token })
    )
  end

  # Unlock Instructions Email
  def unlock_instructions(record, token, opts = {})
    send_gmail_message(
      to: record.email,
      subject: "Unlock your account",
      html_body: render_to_string(:unlock_instructions, formats: [:html], locals: { resource: record, token: token })
    )
  end

  private

  def send_gmail_message(to:, subject:, html_body:)
    user_id = 'default'
    credentials = GOOGLE_AUTHORIZER.get_credentials(user_id)

    if credentials.nil?
      Rails.logger.error "❌ No valid Gmail credentials. Please authorize via /authorize_gmail route."
      return
    end

    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = credentials

    # Same raw email logic as your home#send_message, but in HTML form
    raw_message = <<~EOF
      From: no-reply@yourapp.com
      To: #{to}
      Subject: #{subject}
      MIME-Version: 1.0
      Content-Type: text/html; charset=UTF-8

      #{html_body}
    EOF

    # Gmail API requires CRLF (\r\n)
    raw_message.gsub!("\n", "\r\n")

    begin
      service.send_user_message(
        'me',
        upload_source: StringIO.new(raw_message),
        content_type: 'message/rfc822'
      )
      Rails.logger.info "✅ Sent #{subject} email to #{to} via Gmail API"
    rescue Google::Apis::ClientError => e
      Rails.logger.error "⚠️ Gmail API error: #{e.message}"
      Rails.logger.error e.body if e.respond_to?(:body)
    rescue => e
      Rails.logger.error "⚠️ Unexpected error while sending Gmail API message: #{e.message}"
    end
  end
end
