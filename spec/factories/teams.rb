FactoryGirl.define do
  factory :team do
    transient do
      num_players 0
    end
    game { FactoryGirl.create(:game) }
    sequence(:name) { |n| "Team #{n}" }

    after(:create) do |team, factory|
      factory.num_players.times do
        user = FactoryGirl.create(:user)
        team.registrations << FactoryGirl.create(:registration, user: user, game: team.game)
      end
    end
  end
end

