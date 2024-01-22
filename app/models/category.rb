class Category < ApplicationRecord
  default_scope -> { order(created_at: :asc) }

  has_many :tasks, dependent: :destroy
  # カテゴリの削除や作成に承認が必要とかになったらコメントアウトを外すよ。
  # has_many :approval_requests, dependent: :destroy

  belongs_to :family, optional: true

  validates :name, presence: true
end
