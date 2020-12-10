require 'test_helper'

class MedicalRelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get medical_relationships_create_url
    assert_response :success
  end

  test "should get destroy" do
    get medical_relationships_destroy_url
    assert_response :success
  end
end
