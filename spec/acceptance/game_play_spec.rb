require 'acceptance_helper'

RSpec.describe 'playing a game in progress', js: true do
  before do
    # create game, some teams and photos
    @organizer_user = FactoryGirl.create(:user)
    @game = FactoryGirl.create(:game, organizer: @organizer_user, num_missions: 30, num_teams: 4)
    @mission = @game.missions.first
    @active_team = @game.teams.first
    @active_user = @active_team.users.first
    @game.update!(starts_at: Time.now - 1.hour, ends_at: Time.now + 1.hour)
  end

  it 'allows viewing missions and submitting photos' do
    log_in_as_oauth_user(@active_user) # defined in aceptance_helper
    visit "/dashboard?game_id=#{@game.id}"
    expect(page.body).to include(@mission.name)
    # submit photo
    attach_file("photo_mission_#{@mission.id}", File.absolute_path(Rails.root.join('spec', 'photos', 'pexels-photo-36012.jpg')))
    # TODO: make this work
    # # manually perform the role of automatic javascript form submission
    # # page.execute_script("$('#form_mission_#{@mission.codenum}').submit()")
    # page.execute_script("$('#submit_mission_#{@mission.codenum}').show()")
    # find("input[value='Upload Photo #{@mission.codenum}']").click
    # # manually perform the reload
    # visit "/dashboard?game_id=#{@game.id}"
    # # confirm photo uploaded
    # expect(page.body).to_not include(@mission.name)
    # # confirm can still see mission when viewing all
    # click('Show All')
    # expect(page.body).to include(@mission.name)
  end
end
