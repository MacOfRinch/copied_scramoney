class UsersController < ApplicationController
  def destroy
    @family = Family.find_by(id: params[:family_id])
    @user = User.find_by(family_id: params[:family_id], id: params[:id])
    if @user == current_user
      @user.destroy!
      @family.destroy! if @family.users.size == 0
      redirect_to root_path, success: 'ユーザー情報を削除しました'
    else
      redirect_to root_path, danger: '無効な操作です'
    end
  end
end
