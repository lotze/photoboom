require 'integration_helper'

RSpec.describe 'noop' do
  it 'works' do
    expect do
      ActiveRecord::Base.connection.execute('SELECT 1')
    end.not_to raise_error
  end
end
