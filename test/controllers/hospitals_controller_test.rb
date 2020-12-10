require 'test_helper'

class HospitalsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get hospitals_show_url
    assert_response :success
  end

  test "should get edit" do
    get hospitals_edit_url
    assert_response :success
  end

  test "should get index" do
    get hospitals_index_url
    assert_response :success
  end
end
