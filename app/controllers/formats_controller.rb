class FormatsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :set_family

  def new
    @format = SignupForm.new
    @format.budget = 50_000
  end

  def create
    @format = SignupForm.new(format_params)
    user = @format.save
    if user
      auto_login(user)
      user.update_column(:pocket_money, 0)
      family = user.family
      family.budget_of_last_month ||= family.budget
      family.save!
      redirect_to family_invitation_path(family), success: '登録に成功しました！さっそく家族を招待しましょう。'
    else
      flash.now[:danger] = '入力内容に誤りがあります'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def format_params
    params.require(:signup_form).permit(:family_name, :family_nickname, :budget, :name, :nickname, :email, :password,
                                        :password_confirmation, :avatar)
  end
end
