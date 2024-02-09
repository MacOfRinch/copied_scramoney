class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :set_family

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    @user&.deliver_reset_password_instructions!
    redirect_to(login_path, success: 'パスワードリセット方法を送信しました。')
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
    return if @user.present?

    not_authenticated
    nil
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
    not_authenticated if @user.blank?
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password(params[:user][:password])
      redirect_to(root_path, success: 'パスワードが正常に更新されました')
    else
      flash.now[:danger] = 'パスワードリセットに失敗しました'
      render :edit
    end
  end
end
