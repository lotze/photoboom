require 'acceptance_helper'

RSpec.describe 'creating a game' do
  before do
    @user = FactoryGirl.create(:user)
    log_in_as_oauth_user(@user) # defined in aceptance_helper
  end

  it 'allows creating a game which apepars on the list of games' do
    visit '/games/new'
    game_name = 'Some Test Game Name'
    fill_in 'game_start_location', with: 'some location'
    fill_in 'game_name', with: game_name
    fill_in 'game_starts_at', with: (Time.now + 1.hour).strftime('%m/%d/%Y %H:%M:%S %p')
    #select 'game_timezone', text: 'Hawaii'
    find('input[value="Create Game"]').click
    expect(page.body).to include(game_name)
    visit '/games'
    expect(page.body).to include(game_name)
  end
end
