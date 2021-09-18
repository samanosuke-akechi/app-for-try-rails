require 'test_helper'

class Hoge::PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get hoge_posts_index_url
    assert_response :success
  end

end
