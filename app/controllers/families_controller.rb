require 'date'

class FamiliesController < ApplicationController
  skip_before_action :require_login, only: %i[invitation]
  skip_before_action :set_family, only: %i[invitation]

  def edit
    @family.family_name = nil
  end

  def update
    if @family.update(family_params)
      @family.update_column(:budget_of_last_month, @family.budget)
      redirect_to family_invitation_path(@family), success: 'ステップ1を完了しました。さっそく家族を招待しましょう！'
    else
      flash.now[:danger] = '入力内容に誤りがあります'
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @link_token = params[:linkToken]
    @nonce = params[:nonce]

    users = @family.users
    @each_name_points = each_name_points(users)
    @each_pocket_money = each_pocket_money(users)
    @day_points = day_points(current_user)
  end

  def destroy
    if @family && @family.users.include?(current_user)
      @family.users.each { |user| user.destroy! }
      @family.destroy!
      redirect_to root_path, success: '家族情報を削除し退会しました'
    else
      redirect_to root_path, danger: '無効な操作です'
    end
  end

  def configuration
    @user = current_user
  end

  def invitation
    @family = Family.find(params[:family_id])
    @invitation_code = params[:family_id]
  end

  def advanced_configuration
    @user = current_user
  end

  private

  def family_params
    params.require(:family).permit(:family_name, :family_nickname, :family_avatar, :budget)
  end

  def each_name_points(users)
    result = []
    if @family.sum_points != 0
      users.sort_by { |user| user.points }.reverse.each do |user|
        array = ["#{display_name(user)}: #{user.points}pt (#{user.percent}%)", user.points]
        result << array
      end
    end
    result
  end

  def each_pocket_money(users)
    result = []
    if @family.sum_points != 0
      users.sort_by { |user| user.pocket_money }.reverse.each do |user|
        array = ["#{display_name(user)}: #{user.pocket_money}円", user.pocket_money]
        result << array
      end
    end
    result
  end

  def day_points(user)
    result = []
    if user.calculate_points != 0
      today = Date.today
      first_day = today.beginning_of_month
      day = first_day
      while today >= day
        day_records = user.sum_points_of_the_day(day)
        day_records ||= 0
        array = [l(day, format: :only_day), day_records]
        result << array
        day += 1
      end
    end
    result
  end
end
