require 'test_helper'

class Api::PostalCodeSearchControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get api_postal_code_search_search_url
    assert_response :success
  end

end
