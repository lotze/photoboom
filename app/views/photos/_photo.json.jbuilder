json.extract! photo, :id, :game_id, :mission_id, :user_id, :resource_location, :notes, :created_at, :updated_at
json.url photo_url(photo, format: :json)
