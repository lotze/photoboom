FactoryBot.define do
  factory :team do
    transient do
      num_players { 0 }
    end
    game { FactoryBot.create(:game) }
    sequence(:name) { |n| "Team #{n}" }

    after(:create) do |team, factory|
      factory.num_players.times do
        user = FactoryBot.create(:user)
        team.registrations << FactoryBot.create(:registration, user: user, game: team.game)
      end
    end
  end
end

