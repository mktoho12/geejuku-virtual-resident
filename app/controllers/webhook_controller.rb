class WebhookController < ApplicationController
  protect_from_forgery with: :null_session # CSRF対策無効化

  TOKEN = ENV['FACEBOOK_TOKEN']

  def callback
    unless is_validate_token
      return head :unauthorized
    end
    challenge = params['hub.challenge']
    puts challenge

    render plain: challenge
  end

  private
  def is_validate_token
    params['hub.mode'] == 'subscribe' && params['hub.verify_token'] == TOKEN
  end
end
