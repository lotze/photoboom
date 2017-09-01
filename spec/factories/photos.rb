FactoryGirl.define do
  factory :photo do
    game { FactoryGirl.create(:game) }
    user { FactoryGirl.create(:user) }
    team { FactoryGirl.create(:team) }
    mission { FactoryGirl.create(:mission) }
    width 1480
    height 760
    rejected false
    reviewed false
  end
end
