require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home, aka the root" do
    get root_url
    assert_response :success
  end

  test "should get about" do
    get about_url
    assert_response :success
    assert_select "title", "About | BirdPress"
  end

  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select "title", "Contact | BirdPress"
  end

end
