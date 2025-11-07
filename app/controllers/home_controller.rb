class HomeController < ApplicationController
  include Rails.application.routes.url_helpers

    def index
        
    end

    def about

    end

    def gallery
     @properties = Property.all
  end


  require 'google/apis/gmail_v1'
  require 'googleauth'

  def authorize_gmail
    redirect_to GOOGLE_AUTHORIZER.get_authorization_url(
      base_url: oauth2callback_url
    ), allow_other_host: true
  end

  def contact

  end

  def send_message
    user_id = 'default'
    credentials = GOOGLE_AUTHORIZER.get_credentials(user_id)

    if credentials.nil?
      
      redirect_to GOOGLE_AUTHORIZER.get_authorization_url(base_url: oauth2callback_url), allow_other_host: true
    else
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = credentials


      message_body = create_message(
      "pranav13703@gmail.com",                       # Receiver (you)
      'no-reply@yourapp.com',               # Sender (placeholder)
      "#{params[:subject]} (from #{params[:name]})",  # Subject line
      "Name: #{params[:name]}\nEmail: #{params[:email]}\nSubjetc: #{params[:subject]}\n\nMessage:\n#{params[:message]}"
    )

      service.send_user_message('me', upload_source: StringIO.new(message_body.to_s), content_type: 'message/rfc822')

      flash[:notice] = 'Message sent successfully!'
      redirect_to contact_path
    end
  end

  def oauth2callback
    user_id = 'default'
    credentials = GOOGLE_AUTHORIZER.get_and_store_credentials_from_code(
      user_id: user_id,
      code: params[:code],
      base_url: oauth2callback_url
    )
    redirect_to contact_path
  end

  private
  def create_message(to, from, subject, message_text)
    <<~EOF
    From: #{from}
    To: #{to}
    Subject: #{subject}

    #{message_text}
    EOF
  end

end
