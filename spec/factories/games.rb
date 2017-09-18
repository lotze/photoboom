FactoryGirl.define do
  factory :game do
    transient do
      num_missions 0
      num_teams 0
      num_players_per_team 4
    end

    organizer { FactoryGirl.create(:user) }
    sequence(:name) { |n| "Game #{n}" }
    starts_at Time.now + 1.day
    ends_at Time.now + 1.day + 3.hour
    is_public true
    min_team_size 1
    max_team_size 10
    timezone 'US/Eastern'
    start_location 'the traditional start location'

    after(:create) do |game, factory|
      FactoryGirl.create_list(:mission, factory.num_missions, game: game)
      FactoryGirl.create_list(:team, factory.num_teams, game: game, num_players: factory.num_players_per_team)
    end
  end
end
