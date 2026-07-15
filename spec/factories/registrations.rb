FactoryBot.define do
  factory :registration do
    game { FactoryBot.create(:game) }
    user { FactoryBot.create(:user) }
    sequence(:legal_name) { |n| "True legal testing name #{n}" }
    agree_photo { true }
    agree_waiver { true }
  end
end