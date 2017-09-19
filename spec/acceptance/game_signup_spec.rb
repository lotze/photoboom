require 'acceptance_helper'

RSpec.describe 'signing up for a game' do
  before do
    # create game
    @organizer_user = FactoryGirl.create(:user)
    @game = FactoryGirl.create(:game, organizer: @organizer_user, num_missions: 30)
  end

  it 'allows signup and registration and creating a team' do
    test_name = "New Name"
    test_email = "new_email@mail.com"
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new
    OmniAuth.config.add_mock(:google_oauth2, {
        provider: :google_oauth2,
        info: {
            email: test_email,
            name: test_name
        },
        credentials: {
            token: 'fake_token',
            refresh_token: 'fake_refresh_token'
        }
    })
    visit '/'
    click_on('Enter')
    click_on(@game.name)
    expect(page.body).to include(test_email)
    find('input[id="registration_agree_waiver"]').click
    find('input[id="registration_agree_photo"]').click
    fill_in 'legal_name', with: test_name
    find('input[value="Register"]').click
    expect(page.body).to include(@game.name)
    team_name = 'Conquering Puppies'
    fill_in 'team_name', with: team_name
    find('input[value="Create Team"]').click
    expect(page.body).to include(team_name)
  end

  it 'allows joining a team' do
    team = FactoryGirl.create(:team, game: @game, num_players: 2)
    test_user = FactoryGirl.create(:user)
    log_in_as_oauth_user(test_user) # defined in aceptance_helper
    visit '/'
    click_on(@game.name)
    expect(page.body).to include(test_user.email)
    find('input[id="registration_agree_waiver"]').click
    find('input[id="registration_agree_photo"]').click
    fill_in 'legal_name', with: test_user.name
    find('input[value="Register"]').click
    expect(page.body).to include(@game.name)
    click_on('Join Team')
    expect(page.body).to include(team.name)
  end
end
