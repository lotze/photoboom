# encoding: utf-8
# Autogenerated by the db:seed:dump task
# Do not hesitate to tweak this to your needs

Authorization.create([
  { :provider => "identity", :uid => "1", :user_id => 1, :created_at => "2013-08-17 22:07:15", :updated_at => "2013-08-17 22:07:15" },
  { :provider => "identity", :uid => "2", :user_id => 2, :created_at => "2013-08-17 22:08:13", :updated_at => "2013-08-17 22:08:13" }
])



Game.create([
  { :organizer_id => 1, :name => "Most Awesome Game", :starts_at => "2013-09-18 22:00:00", :ends_at => "2013-09-19 01:00:00", :voting_ends_at => "2013-09-20 01:00:00", :cost => 0, :currency => "USD", :is_public => true, :min_team_size => 3, :max_team_size => 6, :created_at => "2013-08-17 22:07:35", :updated_at => "2013-08-17 22:07:35" }
])



Identity.create([
  { :email => "thomas.lotze@gmail.com", :password_digest => "$2a$10$q8Cy0HAA0vp8SDFNKMhJTOBRZzvrL4CKrrV.WSOJKz/ZPfG6Nf9.q", :created_at => "2013-08-17 22:07:14", :updated_at => "2013-08-17 22:07:14" },
  { :email => "test@thomaslotze.com", :password_digest => "$2a$10$.RSNCv3N1F9.O5eK6kcdBu.rUlUTPo4KbpzacZ1Y5G4fwpK2mITvS", :created_at => "2013-08-17 22:08:13", :updated_at => "2013-08-17 22:08:13" }
])



Registration.create([
  { :team_id => 1, :game_id => 1, :user_id => 2, :is_admin => false, :created_at => "2013-08-17 23:39:32", :updated_at => "2013-08-17 23:39:32" }
])



Mission.create([
  { :game_id => nil, :description => nil, :points => nil, :created_at => nil, :updated_at => nil }
])



Photo.create([
  { :user_id => nil, :game_id => nil, :mission_id => nil, :created_at => nil, :updated_at => nil }
])



Team.create([
  { :game_id => 1, :name => "Pretty Good Team", :created_at => "2013-08-17 23:37:42", :updated_at => "2013-08-17 23:37:42" }
])



User.create([
  { :name => "thomas.lotze@gmail.com", :email => "thomas.lotze@gmail.com", :created_at => "2013-08-17 22:07:14", :updated_at => "2013-08-17 22:07:14" },
  { :name => "test@thomaslotze.com", :email => "test@thomaslotze.com", :created_at => "2013-08-17 22:08:13", :updated_at => "2013-08-17 22:08:13" }
])


