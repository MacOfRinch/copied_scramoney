class TaskUsersController < ApplicationController
  def create
    # 記録処理
    @category = Category.find_by(id: params[:category_id])
    @task = Task.find_by(id: params[:id])
    if @task
      record = TaskUser.create!(task_id: @task.id, user_id: current_user.id, family_id: @family.id,
                                count: params[:task_user][:count].to_i)
      current_user.update_column(:points, (current_user.points + @task.points * record.count))
      @family.users.each do |user|
        user.update_column(:pocket_money, user.calculate_pocket_money)
      end
      redirect_to new_family_record_path, success: 'タスクが記録されました'
    else
      redirect_to new_family_record_path, danger: '無効な操作です'
    end
  end

  def destroy
    # 記録削除処理
    record = TaskUser.find_by(id: params[:id])
    if record && record.user == current_user
      current_user.update_column(:points, (current_user.points - record.task.points * record.count))
      current_user.cancel(record)
      @family.users.each do |user|
        user.update_column(:pocket_money, user.calculate_pocket_money)
      end
      redirect_to family_records_path, success: '記録を削除しました', status: :see_other
    else
      redirect_to family_records_path, danger: '無効な操作です'
    end
  end
end
