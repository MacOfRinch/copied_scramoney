require 'date'

class User < ApplicationRecord
  authenticates_with_sorcery!

  default_scope -> { order(created_at: :asc) }

  has_many :task_users, dependent: :destroy
  has_many :tasks, through: :task_users
  has_many :approval_requests
  has_many :approval_statuses
  has_many :notices, dependent: :destroy
  has_many :reads, dependent: :destroy
  has_many :authentications, dependent: :destroy
  has_one :nonce
  accepts_nested_attributes_for :authentications
  belongs_to :family, optional: true

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, uniqueness: true, allow_nil: true
  validates :line_user_id, uniqueness: true, allow_nil: true

  attr_accessor :linkToken

  def self.find_by_oauth_provider(provider, uid)
    find_by(provider:, line_user_id: uid)
  end

  def cancel(task)
    task_users.destroy(task)
  end

  def calculate_points
    task_users.this_month.map { |record| record.task.points * record.count }.sum
  end

  def sum_points_of_the_day(date)
    task_users.where(created_at: date.all_day).map { |record| record.task.points * record.count }.sum
  end

  def calculate_points_of_last_month
    task_users.last_month.map { |record| record.task.points * record.count }.sum
  end

  def percent
    total = family.sum_points
    if total.zero?
      1.0 / family.users.size
    else
      (points * 100.0 / total).round(1)
    end
  end

  def percent_of_last_month
    total = family.sum_points_of_last_month
    if total.zero?
      1.0 / family.users.size
    else
      (points_of_last_month * 100.0 / total).round(1)
    end
  end

  def calculate_pocket_money
    pocket_money = calculate_rounded_down_pocket_money[:rounded_down]
    return if family.sum_points == 0

    sum_of_rounded_down_pm = family.users.sum { |user| user.calculate_rounded_down_pocket_money[:rounded_down] }
    difference = ((family.budget / Unit) * Unit - sum_of_rounded_down_pm) / Unit
    if difference >= 1
      list = []
      family.users.each do |user|
        element = user.calculate_rounded_down_pocket_money[:diff]
        list << element
      end
      rounded_up_list = list.max(difference)
      selected_users = family.users.select do |user|
        rounded_up_list.include?(user.calculate_rounded_down_pocket_money[:diff])
      end
      pocket_money += Unit if selected_users.include?(self) && difference >= selected_users.size
    end

    pocket_money
  end

  def calculate_rounded_down_pocket_money
    total = family.budget
    if family.sum_points.zero?
      pm = (total / family.users.size)
    else
      ratio = points.to_f / family.sum_points
      pm = total * ratio
    end
    rounded_down = (pm / Unit).to_i * Unit
    { rounded_down:, diff: (pm - rounded_down) }
  end

  def calculate_pocket_money_of_last_month
    sum_of_rounded_down_pm = family.users.sum do |user|
      user.calculate_rounded_down_pocket_money_of_last_month[:rounded_down]
    end
    count = ((family.budget_of_last_month / Unit) * Unit - sum_of_rounded_down_pm) / Unit
    pocket_money = calculate_rounded_down_pocket_money_of_last_month[:rounded_down]
    if count >= 1
      list = []
      family.users.each do |user|
        element = user.calculate_rounded_down_pocket_money_of_last_month[:diff]
        list << element
      end
      rounded_up_list = list.max(count)
      selected_users = family.users.select do |user|
        rounded_up_list.include?(user.calculate_rounded_down_pocket_money_of_last_month[:diff])
      end
      pocket_money += Unit if selected_users.include?(self)
    end
    pocket_money
  end

  def calculate_rounded_down_pocket_money_of_last_month
    total = family.budget_of_last_month
    if family.sum_points_of_last_month.zero?
      pm = (total / family.users.size)
    else
      ratio = sum_points_of_last_month.to_f / family.sum_points_of_last_month
      pm = total * ratio
    end
    rounded_down = (pm / Unit).to_i * Unit
    { rounded_down:, diff: (pm - rounded_down) }
  end

  def link_line_account(line_auth)
    update_columns(line_user_id: line_auth.uid, provider: 'line')
  end
end
