class LineEventsController < ApplicationController
  require 'line/bot'
  require 'net/https'
  require 'uri'
  require 'json'
  skip_before_action :require_login
  skip_before_action :set_family
  protect_from_forgery except: [:recieve]

  def recieve
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    head :bad_request unless line_client.validate_signature(body, signature)
    events = line_client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          if event.message['text'] == 'アカウント連携'
            userId = event['source']['userId']
            replyToken = event['replyToken']
            uri = URI.parse("https://api.line.me/v2/bot/user/#{userId}/linkToken")
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE if Rails.env.development? || Rails.env.test?
            req = Net::HTTP::Post.new(uri.path)
            req['Content-Type'] = 'application/json'
            req['Authorization'] = "Bearer #{ENV['LINE_CHANNEL_TOKEN']}"
            response = http.request(req)
            token = JSON.parse(response.body)['linkToken']
            if response.code.to_i == 200
              message = {
                type: 'text',
                text: "連携申請ありがとうございます！\n下記のURLからアプリの再ログインに進んでください。\nURLの有効期間は10分間です。\nhttps://#{Settings.default_url_options.host}/login?linkToken=#{token}"
              }
              line_client.reply_message(replyToken, message)
            else
              redirect_to root_path, danger: '問題が発生しました。お手数ですが、初めからやり直してください。'
            end
          end
        end
      end
      if event['type'] == 'accountLink'
        if event['link']['result'] == 'ok'
          nonce = event['link']['nonce']
          correct_nonce = Nonce.find_by!(nonce:)
          if correct_nonce.active?(nonce)
            user = User.find(correct_nonce.user_id.to_s)
            user.update_columns(provider: 'line', line_user_id: event['source']['userId'], line_flag: true)
            Authentication.create(user_id: user.id, provider: 'line', uid: user.line_user_id)
            correct_nonce.destroy!
          else
            logger.error('有効期限切れのようです')
          end
        else
          logger.error('link_tokenが間違ってるっぽいです')
        end
      end
      logger.info("#{event['type']}イベントですね")
    end
    head :ok
  end

  def unconnect
    auth = Authentication.find_by(user_id: current_user.id, provider: 'line', uid: current_user.line_user_id)
    auth.destroy!
    current_user.update_columns(provider: nil, line_user_id: nil, line_flag: false)
  end

  private

  def line_client
    @line_client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
