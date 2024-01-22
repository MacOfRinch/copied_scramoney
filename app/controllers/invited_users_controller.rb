class InvitedUsersController < ApplicationController
  skip_before_action :set_family
  skip_before_action :require_login

  def new
    @user = User.new
  end

  def create
    # 他の家族でログインしている人を統合する処理だよ。
    if logged_in?
      old_family = current_user.family
      new_family = Family.find(params[:invitation_code])
      current_user.update_column(:family_id, new_family.id)
      old_family.destroy! if old_family.users.size == 0
      redirect_to family_path(new_family), success: "#{new_family.family_name}家に招待され、メンバーに加わりました！"
    else
      # 通常の招待処理だよ。
      @user = User.new(user_params)
      @user.pocket_money = 0
      if @user.save
        auto_login(@user)
        family = Family.find(params[:user][:family_id])
        redirect_to family_path(family), success: 'Scramoneyへようこそ!'
      else
        flash.now[:danger] = '入力内容に誤りがあります'
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :nickname, :email, :password, :password_confirmation, :family_id)
  end
end
