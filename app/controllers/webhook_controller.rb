#coding utf-8

require 'json'
require 'httpclient'

class WebhookController < ApplicationController
  include WebhookHelper

  protect_from_forgery with: :null_session # CSRF対策無効化
  TOKEN = ENV['FACEBOOK_TOKEN']
  ACCESS_TOKEN = ENV['FACEBOOK_ACCESS_TOKEN']

  def callback

    request_data = JSON.parse(request.body.read, {:symbolize_names => true})
    sender_id = request_data[:entry][0][:messaging][0][:sender][:id]
    puts params

    httpclient = HTTPClient.new
    httpclient.post_content(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{ACCESS_TOKEN}",
      {recipient: {id: sender_id}, message: {text: inmu}}.to_json,
      'Content-Type' => 'application/json'
    )
    head :ok
  end

  def callback_subscribe
    unless is_validate_token? && params['hub.mode'] == 'subscribe'
      return head :unauthorized
    end

    challenge = params['hub.challenge']
    render plain: challenge if request.get?

    head :ok
  end

  private
  def is_validate_token?
    params['hub.verify_token'] == TOKEN
  end
end
