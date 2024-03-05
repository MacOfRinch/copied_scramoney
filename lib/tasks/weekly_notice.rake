require 'line/bot'

namespace :weekly_notice do
  desc '今週のお小遣いをお知らせするよ。'
  task generate: :environment do
    line_client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
    families = Family.all
    families.each do |family|
      family.users.each do |user|
        user.pocket_money ||= user.calculate_pocket_money
        user.save!
        next if user.line_flag.nil? || user.pocket_money.nil?

        records_url = 'https://' + Settings.default_url_options.host + Rails.application.routes.url_helpers.family_records_path(user.family)
        message = {
          type: 'text',
          text: "現時点でのあなたの来月のお小遣いは\n#{user.pocket_money.to_fs(:delimited)}円です！\n記録漏れはありませんか？\n#{records_url}"
        }
        line_client.push_message(user.line_user_id, message)
      end
    end
  end
end
