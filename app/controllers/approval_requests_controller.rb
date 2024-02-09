class ApprovalRequestsController < ApplicationController
  require 'line/bot'

  before_action :set_request

  def update
    status = ApprovalStatus.find_by(approval_request_id: @request.id, user_id: current_user.id)
    status.update!(status: :accept)
    @family.apply_changes_if_approved(@request)
    # 承認したものは通知から削除するよ。
    Notice.find_by(approval_request_id: @request.id, user_id: current_user.id).destroy!
    redirect_to family_path(@family), success: '変更を承認しました'
  end

  def destroy
    status = ApprovalStatus.find_by(approval_request_id: @request.id, user_id: current_user.id)
    status.update!(status: :refuse)
    @family.apply_changes_if_approved(@request)
    # 上と同様、拒否ったものは通知から削除するよ。
    if @request.requester.line_flag
      message = {
        type: 'text',
        text: "#{current_user.name}さんによってあなたの家族プロフィール変更申請が却下されました。"
      }
      line_client.push_message(@request.requester, message)
    end
    Notice.find_by(approval_request_id: @request.id, user_id: current_user.id).destroy!
    redirect_to family_path(@family), success: '変更を拒否しました'
  end

  private

  def set_request
    @request = ApprovalRequest.find(params[:id])
  end

  def line_client
    @line_client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end
