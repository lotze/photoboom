FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    sequence(:name) { |n| "User #{n}" }

    factory :registered_user do
      transient do
        game { FactoryBot.create(:game) }
      end

      after(:create) do |user, factory|
        FactoryBot.create(:registration, user: user, game: factory.game)
      end
    end
  end
end
