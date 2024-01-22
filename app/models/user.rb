class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :posts, dependent: :destroy
end
