FactoryBot.define do
  factory :category do
    association :user
    sequence(:name) { |n| "Category #{n}" }
  end

  factory :item do
    association :user
    association :category
    association :location
    sequence(:name) { |n| "Item #{n}" }
    purchase_value { 1_000 }
    current_value { 500 }
  end

  factory :location do
    association :user
    sequence(:name) { |n| "Location #{n}" }
  end

  factory :usage do
    association :item
    used_on { "2025-09-01" }
  end

  factory :user do
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "topsecret" }
  end
end
