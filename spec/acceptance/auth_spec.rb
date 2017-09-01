require 'acceptance_helper'

RSpec.describe 'authorization' do
  describe 'user authenticates using google' do
    it 'allows them to log in afterwards using their password' do
      # visit '/auth/identity/register'
      # user_email = 'email@example.com'
      # user_password = 'password'
      # fill_in 'email', with: user_email
      # fill_in 'password', with: user_password
      # fill_in 'password_confirmation', with: user_password
      # response = find('input[value="Create"]').click
      # visit '/signout'
      # visit '/signin'
      # fill_in 'auth_key', with: user_email
      # fill_in 'password', with: user_password
      # find('input[value="Login"]').click
      # visit '/home'
      # TODO: since we are redirecting to enter code if they have no codes entered,
      #   figure out how to confirm that they are logged in here :s
      # expect(page.body).to include(user_email)
    end
  end

end
