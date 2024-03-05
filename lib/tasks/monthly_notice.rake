require 'line/bot'

namespace :monthly_notice do
  desc '先月のポイント、お小遣いを通知するよ。'
  task generate: :environment do
    line_client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
    families = Family.all
    families.each do |family|
      family.users.each do |user|
        notice = Notice.create!(title: '今月のお小遣いのお知らせ', family_id: family.id, user_id: user.id,
                                notice_type: :pocket_money)
        Read.create!(user_id: user.id, notice_id: notice.id, checked: false)
        next if user.line_flag.nil? || user.pocket_money_of_last_month.nil?

        message = {
          type: 'text',
          text: "1ヶ月お疲れ様でした！\nあなたの今月のお小遣いは、#{user.pocket_money_of_last_month.to_fs(:delimited)}円です！"
        }
        line_client.push_message(user.line_user_id, message)
      end
    end
  end
end
