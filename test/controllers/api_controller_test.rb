require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get games" do
    get :games
    assert_response :success
  end

  test "should get photos" do
    get :photos
    assert_response :success
  end

  test "should get signup" do
    get :signup
    assert_response :success
  end

  test "should get join" do
    get :join
    assert_response :success
  end

  test "should get submit" do
    get :submit
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

end
