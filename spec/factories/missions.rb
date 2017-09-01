FactoryGirl.define do
  factory :mission do
    game { FactoryGirl.create(:game) }
    sequence(:description) { |n| "More detail for mission #{n}" }
    sequence(:name) { |n| "Mission #{n}" }
    sequence(:codenum) { |n| n+1 }
    points 10
  end
end
