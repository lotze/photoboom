json.array!(@registrations) do |membership|
  json.extract! membership, 
  json.url registration_url(membership, format: :json)
end
