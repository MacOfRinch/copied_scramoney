class UserProfilesController < ApplicationController
  before_action :set_user

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to family_user_profile_path, success: 'プロフィールが更新されました'
    else
      flash.now[:danger] = '正常に更新されませんでした'
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :nickname, :avatar, :avatar_cache)
  end
end
