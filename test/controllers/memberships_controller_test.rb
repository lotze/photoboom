require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase
  setup do
    @registration = memberships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registrations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create membership" do
    assert_difference('Membership.count') do
      post :create, registration: {  }
    end

    assert_redirected_to registration_path(assigns(:registration))
  end

  test "should show membership" do
    get :show, id: @registration
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @registration
    assert_response :success
  end

  test "should update membership" do
    patch :update, id: @registration, registration: {  }
    assert_redirected_to registration_path(assigns(:registration))
  end

  test "should destroy membership" do
    assert_difference('Membership.count', -1) do
      delete :destroy, id: @registration
    end

    assert_redirected_to registrations_path
  end
end
