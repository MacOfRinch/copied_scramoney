class ApprovalRequest < ApplicationRecord
  has_many :approval_statuses
  has_many :notices
  has_many :approvers, class_name: 'User', foreign_key: :user_id
  has_one :temporary_family_data

  belongs_to :family
  belongs_to :requester, class_name: 'User', foreign_key: :user_id

  after_save :check_if_approved

  enum status: { waiting: 0, accepted: 1, refused: 2 }

  def check_if_approved
    if approval_statuses.refuse.exists?
      update_column(:status, :refused)
    elsif approval_statuses.waiting.exists?
      update_column(:status, :waiting)
    else
      update_column(:status, :accepted)
    end
  end
end
