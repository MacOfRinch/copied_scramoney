class SignupForm
  include ActiveModel::Model

  attr_accessor :family_name, :family_nickname, :family_avatar, :budget,
                :name, :nickname, :email, :password, :password_confirmation, :avatar, :avatar_cache

  validates :family_name, presence: true
  validates :budget, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1_000 }
  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  
  validate :validate_user
  validate :validate_family

  def save
    family = Family.create(family_name:, family_nickname:, family_avatar:,
                           budget:)
    user = User.create(family_id: family.id, name:, nickname:, email:, password:,
                       password_confirmation:, avatar:, avatar_cache:)
    return false if family.invalid? || user.invalid?
    # バリデーション通ってたらuserでログインしたいから返り値をuserにしておくよ。
    user
  end

  private

  def validate_user
    user = User.new(:name, :nickname, :email, :password, :password_confirmation, :avatar, :avatar_cache)
    return if user.valid?
    user.errors.each do |attribute, error|
      errors.add(attribute, error)
    end
  end

  def validate_family
    family = Family.new(:family_name, :family_nickname, :family_avatar, :budget)
    return if family.valid?
    family.errors.each do |attribute, error|
      errors.add(attribute, error)
    end
  end
end