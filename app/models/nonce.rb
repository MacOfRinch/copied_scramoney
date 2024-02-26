class Nonce < ApplicationRecord
  belongs_to :user

  def active?(nonce_value)
    value = Nonce.find_by(nonce: nonce_value)
    return false unless value
    return true if value.expires_at >= Time.now

    value.destroy
    false
  end
end
