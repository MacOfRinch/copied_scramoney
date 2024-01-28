class Family < ApplicationRecord
  require 'line/bot'

  after_create :copy_default_categories_and_tasks

  # mount_uploader :family_avatar, ImageUploader

  before_create lambda {
                  while id.blank? || Family.find_by(id:).present?
                    self.id = format('%016d', SecureRandom.random_number(10**16))
                  end
                }

  attr_accessor :approval_request

  has_many :users, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :notices, dependent: :destroy
  has_many :task_users, dependent: :destroy
  has_many :approval_requests, dependent: :destroy

  validates :family_name, presence: true
  validates :budget, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1000 }

  enum :status, {
    normal: 0,
    guest: 1
  }

  # 家族の総取得ポイント数を計算するメソッドだよ。
  def sum_points
    points = 0
    users.each do |user|
      next if user.task_users.this_month.blank?

      user.task_users.this_month.each do |record|
        points += record.task.points * record.count
      end
    end
    points
  end

  # いい方法見つかったら消すよ。
  def sum_points_of_last_month
    points = 0
    users.each do |user|
      next if user.task_users.last_month.blank?

      user.task_users.last_month.each do |record|
        points += record.task.points * record.count
      end
    end
    points
  end

  def monopolized_by_one?
    result = false
    users.each do |user|
      next if user.calculate_points < sum_points
      result = true
    end
    result
  end

  def copy_default_categories_and_tasks
    default_tasks = Task.where(family_id: nil)
    default_categories = Category.where(family_id: nil)

    default_categories.each do |category|
      new_category = category.dup
      new_category.family_id = id
      # その他を常に最後にしたいからcreated_atの値をいじるよ。
      new_category.created_at = 'Fry, 31 Dec 9999 23:59:59' if new_category.name == 'その他'
      new_category.save
    end

    default_tasks.each do |task|
      new_task = task.dup
      new_task.family_id = id
      new_task.category_id = case new_task.category_name
                             when 'housework'
                               categories.find_by(name: '家事').id
                             when 'work'
                               categories.find_by(name: '仕事').id
                             when 'study_work'
                               categories.find_by(name: '勉強(仕事・資格)').id
                             when 'school'
                               categories.find_by(name: '学校').id
                             when 'study'
                               categories.find_by(name: '勉強(学校)').id
                             when 'pet'
                               categories.find_by(name: 'ペット').id
                             when 'extra'
                               categories.find_by(name: 'その他').id
                             end

      new_task.save
    end
  end

  def apply_changes_if_approved(request)
    request.check_if_approved
    if request.status == 'accepted'
      merge_temporary_data(request)
      # 承認されたことをLINEで通知するよ。
      requester = request.requester
      users.each { |user| user.update_column(:pocket_money, user.calculate_pocket_money) }
      if requester.line_flag
        message = {
          type: 'text',
          text: "あなたの申請が承認され、家族プロフィールが更新されました！\n名字：#{requester.family.family_name}\nニックネーム：#{requester.family.family_nickname}\nお小遣い予算：#{requester.family.budget.to_s(:delimited)}円"
                  }
        line_client.push_message(request.requester.line_user_id, message)
      end
    end
    unless request.status == 'waiting'
      notices = Notice.where(approval_request_id: request.id)
      notices.each do |notice|
        notice.destroy
      end
    end
  end

  # プロフィール編集リクエストが通った時に一時保管データをマージするメソッドだよ。上で使ってるよ。
  def merge_temporary_data(request)
    temporary_data = TemporaryFamilyDatum.find_by(approval_request_id: request.id)
    update_columns(family_name: temporary_data.name,
                   family_nickname: temporary_data.nickname,
                   family_avatar: temporary_data.avatar,
                   budget: temporary_data.budget
                   )
  end

  def line_client
    @line_client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end
