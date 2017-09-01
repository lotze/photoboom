FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    sequence(:name) { |n| "User #{n}" }

    factory :registered_user do
    end
  end
end
