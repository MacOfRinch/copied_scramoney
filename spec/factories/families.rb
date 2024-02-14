FactoryBot.define do
  factory :family do
    family_name { "ぴっぴ" }
    family_nickname { "テストファミリー" }
    budget { 50000 }
    budget_of_last_month { 100000 }

    trait :with_users do
      transient do
        users_count { 4 }
      end
      after(:build) do |family, evaluator|
        family.users << build_list(:user, evaluator.users_count)
      end
    
      trait :another_family do
        family_name { "バーンデッド" }
        family_nickname { "" }
      end
    end
  end
end
