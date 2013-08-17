json.array!(@memberships) do |membership|
  json.extract! membership, 
  json.url membership_url(membership, format: :json)
end
