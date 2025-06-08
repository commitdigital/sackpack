FactoryBot.define do
  factory :category do
    association :user
    sequence(:name) { |n| "Category #{n}" }
  end

  factory :location do
    association :user
    sequence(:name) { |n| "Location #{n}" }
  end

  factory :user do
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "topsecret" }
  end
end
