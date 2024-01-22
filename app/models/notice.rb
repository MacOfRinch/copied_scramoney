class Notice < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :family
  belongs_to :approval_request, optional: true

  has_many :reads, dependent: :destroy

  enum notice_type: { pocket_money: 0, approval_request: 1, accepted_approvement: 2, refused_approvement: 3 }
end
