class ApprovalStatus < ApplicationRecord
  belongs_to :approval_request
  belongs_to :approver, class_name: 'User', foreign_key: :user_id

  enum status: { waiting: 0, accept: 1, refuse: 2 }
end
