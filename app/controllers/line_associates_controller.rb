class LineAssociatesController < ApplicationController
  def new
    @user = current_user
    @family = @user.family
  end

  def create
    @user = User.find_by(id: params[:user_id])
    unless @user.family == Family.find_by(id: params[:family_id]) || current_user == @user
      redirect_to family_path(@user.family), danger: '無効な操作です'
    end
    @user.update_column(:line_flag, true)
    redirect_to new_family_user_line_associates_path(@family, @user), success: 'LINE通知を受け取るように設定しました'
  end

  def destroy
    @user = User.find_by(id: params[:user_id])
    unless @user.family == Family.find_by(id: params[:family_id]) || current_user == @user
      redirect_to family_path(@user.family), danger: '無効な操作です'
    end
    @user.update_column(:line_flag, false)
    redirect_to new_family_user_line_associates_path(@family, @user), success: 'LINE通知を受け取らないように設定しました'
  end
end
