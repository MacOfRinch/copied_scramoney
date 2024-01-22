class TaskUser < ApplicationRecord
  belongs_to :task
  belongs_to :user
  belongs_to :family

  # enum :count_name, { counts: 0, hours: 1 }
  validates :count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  scope :this_month, -> { where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month) }
  scope :last_month, lambda {
                       where(created_at: Time.zone.now.prev_month.beginning_of_month..Time.zone.now.prev_month.end_of_month)
                     }
end
