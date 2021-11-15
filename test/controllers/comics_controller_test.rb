require 'test_helper'

class ComicsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get comics_index_url
    assert_response :success
  end

  test "should get new" do
    get comics_new_url
    assert_response :success
  end

end
