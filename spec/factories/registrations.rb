FactoryGirl.define do
  factory :registration do
    game { FactoryGirl.create(:game) }
    user { FactoryGirl.create(:user) }
    sequence(:legal_name) { |n| "True legal testing name #{n}" }
    agree_photo true
    agree_waiver true
  end
end