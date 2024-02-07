class Nonce < ApplicationRecord
  belongs_to :user

  def active?(nonce_value)
    value = Nonce.find_by(nonce: nonce_value)
    return false unless value
    if value.expires_at >= Time.now
      return true
    else
      value.destroy
      return false
    end
  end
end
