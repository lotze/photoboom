FactoryGirl.define do
  factory :game do
    organizer { FactoryGirl.create(:user) }
    sequence(:name) { |n| "Game #{n}" }
    starts_at Time.now + 1.day
    end_at Time.now + 1.day + 3.hour
    is_public true
    min_team_size 1
    max_team_size 10
    timezone 'US/Eastern'
  end
end
