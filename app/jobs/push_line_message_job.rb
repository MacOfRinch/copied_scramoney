class PushLineMessageJob < ApplicationJob
  require 'line/bot'
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(*args)
    # Do something later
    
  end

  private

  def line_client
    @line_client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  protected

  def default_url_options
    { host: ENV['HEROKU_APP_NAME'] }
  end
end
