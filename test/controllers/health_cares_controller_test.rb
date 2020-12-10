require 'test_helper'

class HealthCaresControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get health_cares_new_url
    assert_response :success
  end

  test "should get index" do
    get health_cares_index_url
    assert_response :success
  end

  test "should get edit" do
    get health_cares_edit_url
    assert_response :success
  end
end
