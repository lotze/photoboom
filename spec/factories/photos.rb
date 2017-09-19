FactoryGirl.define do
  factory :photo do
    transient do
      photo_type nil
    end

    game { FactoryGirl.create(:game) }
    user { FactoryGirl.create(:user) }
    team { FactoryGirl.create(:team) }
    mission { FactoryGirl.create(:mission) }
    width 1480
    height 760
    rejected false
    reviewed false

    after(:create) do |photo, factory|
      if factory.photo_type == :vertical
        photo_filename ='pexels-photo-36012.jpg'
      elsif factory.photo_type == :horizontal
        photo_filename = 'pexels-photo-207962.jpeg'
      end

      if photo_filename
        photo_filepath = Rails.root.join('spec', 'photos', photo_filename)
        File.open(photo_filepath) do |f|
          photo.photo = f
          photo.save
        end
      end
    end
  end
end
