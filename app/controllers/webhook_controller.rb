#coding utf-8

require 'json'
require 'httpclient'

class WebhookController < ApplicationController
  protect_from_forgery with: :null_session # CSRF対策無効化

  TOKEN = ENV['FACEBOOK_TOKEN']

  def callback

    params = JSON.parse(request.body.read, {:symbolize_names => true})
    puts params

    httpclient = HTTPClient.new
    httpclient.post_content(
      'https://graph.facebook.com/v2.6/me/messages?access_token=EAABoiBhMihsBABXpnaNQZBg1zmsiFINZB4QVZCPR3qliiEuKxeU6Ksv8BRrQN1LrC6V2g9WbMTjJyqhoI6sZAWjemFOUGLZA4JnpzmZCsUbb7v4lVrBqMYS4mWbLH0RhKwNUmzeUfbJz4hehejrNpbNvB8YCJgHeltYX0j74qFBgZDZD',
      {recipient: {id: '1764875153553086'}, message: {text: 'は？'}}.to_json,
      'Content-Type' => 'application/json'
    )
    head :ok
  end

  def callback_subscribe
    unless is_validate_token && params['hub.mode'] == 'subscribe'
      return head :unauthorized
    end

    challenge = params['hub.challenge']
    render plain: challenge if request.get?

    head :ok
  end

  private
  def is_validate_token
    params['hub.verify_token'] == TOKEN
  end
end
