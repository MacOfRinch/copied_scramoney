class UserSessionsController < ApplicationController
  include GuestUserManagement
  skip_before_action :require_login, only: %i[new create login_as_guest]
  skip_before_action :set_family, only: %i[new create login_as_guest]

  require 'securerandom'

  def new
    logout
    reset_session
    @link_token = params[:linkToken]
  end

  def create
    @link_token = params[:linkToken]
    @user = login(params[:email], params[:password], params[:remember_me], params[:linkToken])
    # linkTokenがあった場合、後付けでのアカウント連携を行うよ。有効期限10分のnonceを発行して認証に使うよ。
    if @user && @link_token
      new_nonce = Nonce.create!(user_id: @user.id, nonce: @user.id.to_s + SecureRandom.hex(16), expires_at: Time.now + 10.minutes)
      nonce = new_nonce.nonce
      redirect_to "https://access.line.me/dialog/bot/accountLink?linkToken=#{@link_token}&nonce=#{nonce}", allow_other_host: true
    elsif @user
      redirect_to family_path(@user.family), success: 'ログインに成功しました！'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def login_as_guest
    user = @family.users.find_by(name: 'ゲスト')
    auto_login(user)
    redirect_to family_path(@family), success: 'ゲストとしてログインしました！'
  end

  def destroy
    # ゲストログインだった場合、お片付けするよ。
    if @family.status == "guest"
      @family.task_users.each do |record|
        record.destroy!
      end
      @family.tasks.each do |task|
        task.destroy!
      end
      @family.users.each do |user|
        user.destroy! unless user == current_user
      end
      @family.destroy!
      current_user.destroy!
    else
      logout
    end
    redirect_to login_path, success: 'ログアウトしました', status: :see_other # see_otherがないと大変なことになる
  end
end
