FactoryBot.define do
  factory :family do
    family_name { 'ぴっぴ' }
    family_nickname { 'テストファミリー' }
    budget { 50_000 }
    budget_of_last_month { 100_000 }

    trait :with_users do
      transient do
        users_count { 4 }
      end
      after(:build) do |family, evaluator|
        family.users << build_list(:user, evaluator.users_count, family: family)
      end
    end

    trait :another_family do
      family_name { 'マッシュルーム' }
      family_nickname { '' }
    end
  end
end
