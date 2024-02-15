FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}" }
    sequence(:nickname) { |n| "謎の男#{n}" }
    sequence(:email) { |n| "bakayaro_#{n}@example.com" }
    sequence(:password) { |n| "password" }
    family
  end
end
