require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get delete" do
    get :delete
    assert_response :success
  end

end
