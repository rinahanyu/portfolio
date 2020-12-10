require 'test_helper'

class MedicalHistoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get medical_histories_new_url
    assert_response :success
  end

  test "should get index" do
    get medical_histories_index_url
    assert_response :success
  end

  test "should get edit" do
    get medical_histories_edit_url
    assert_response :success
  end
end
