require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new user path?" do
    get new_user_path
    assert_response :success
  end

end
