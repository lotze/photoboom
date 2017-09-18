require 'acceptance_helper'

RSpec.describe 'playing a game in progress' do
  before do
    # create game, some teams and photos
    @organizer_user = FactoryGirl.create(:user)
    @game = FactoryGirl.create(:game, organizer: @organizer_user, num_missions: 30, num_teams: 4)
    @mission = @game.missions.first
    @active_team = @game.teams.first
    @active_user = @active_team.users.first
    @photo = FactoryGirl.create(:photo, mission: @mission, user: @active_user, team: @active_team, game: @game)
    @game.update_attributes!(starts_at: Time.now - 1.hour, ends_at: Time.now + 1.hour)
  end

  it 'allows viewing missions and submitting photos' do
    log_in_as_oauth_user(@active_user) # defined in aceptance_helper
    visit '/'
    expect(page.body).to include(@mission.name)
    # TODO: submit photo
  end
end
