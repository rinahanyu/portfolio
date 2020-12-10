require 'test_helper'

class DailyRecordsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get daily_records_new_url
    assert_response :success
  end

  test "should get index" do
    get daily_records_index_url
    assert_response :success
  end

  test "should get show" do
    get daily_records_show_url
    assert_response :success
  end

  test "should get edit" do
    get daily_records_edit_url
    assert_response :success
  end
end
