class Task < ApplicationRecord
  default_scope -> { order(created_at: :asc) }

  has_many :task_users, dependent: :destroy
  has_many :users, through: :task_users
  has_many :approval_requests

  belongs_to :category, optional: true
  belongs_to :family, optional: true

  validates :title, presence: true
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  enum :category_name, {
    housework: 0,
    work: 1,
    study_work: 2,
    school: 3,
    study: 4,
    pet: 5,
    extra: 6
  }
end
