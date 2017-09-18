require 'acceptance_helper'

RSpec.describe 'managing a game in progress' do
  before do
    # create game, some teams and photos
    @organizer_user = FactoryGirl.create(:user)
    @game = FactoryGirl.create(:game, organizer: @organizer_user, num_missions: 30, num_teams: 4)
    @mission = @game.missions.first
    @active_team = @game.teams.first
    @active_user = @active_team.users.first
    @photo = FactoryGirl.create(:photo, mission: @mission, user: @active_user, team: @active_team, game: @game)
  end

  it 'allows review and rejection and unrejection of photos' do
    log_in_as_oauth_user(@organizer_user) # defined in aceptance_helper
    visit "/games/#{@game.id}/admin_review"
    expect(page.body).to include(@mission.name)
    expect(page.body).to include(@active_team.name)
    # find a specific photo Rejection link
    reject_link = find("a[href='/photos/reject?id=#{@photo.id}']", text: "Reject")
    reject_link.click
    # confirm photo not listed in review
    visit "/games/#{@game.id}/admin_review"
    expect(page.body).to_not include(@mission.name)
    expect(page.body).to_not include(@active_team.name)
    # confirm photo listed as rejected
    visit "/games/#{@game.id}/rejected"
    expect(page.body).to include(@mission.name)
    expect(page.body).to include(@active_team.name)
    # unreject
    accept_link = find("a[href='/photos/accept?id=#{@photo.id}']", text: "Accept")
    accept_link.click
    # confirm photo listed as approved
    visit "/photos?game_id=#{@game.id}"
    expect(page.body).to_not include("<td>X</td>")
  end
end
