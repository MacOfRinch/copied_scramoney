class RecordsController < ApplicationController
  include UsersHelper

  def index
    @records = TaskUser.where(family_id: @family.id).this_month.order(created_at: :desc).page(params[:page])
    @records_of_last_month = TaskUser.where(family_id: @family.id).last_month.order(created_at: :desc).page(params[:page])
  end

  def new
    @categories = Category.where(family_id: @family.id)
    @tasks = Task.where(family_id: @family.id)
    @record = TaskUser.new
  end

  def create
    tasks_params = params[:task_user][:tasks]
    tasks_params.each do |task_id, task_count|
      id = task_id.to_i
      count = task_count[:count].to_i
      next unless count > 0

      task = Task.find(id)
      TaskUser.create!(task_id: id, user_id: current_user.id, family_id: @family.id, count:)
      current_user.update_column(:points, (current_user.points + task.points * count))
    end
    @family.users.each do |user|
      user.update_column(:pocket_money, user.calculate_pocket_money)
    end
    redirect_to family_records_path(@family), success: 'タスクを記録しました！'
  end

  def destroy
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

  def task_index
    @category = Category.find(params[:id])
    @record = TaskUser.new
  end
end
