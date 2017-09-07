require 'test_helper'

class PrimaryPhotosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @primary_photo = primary_photos(:one)
  end

  test "should get index" do
    get primary_photos_url
    assert_response :success
  end

  test "should get new" do
    get new_primary_photo_url
    assert_response :success
  end

  test "should create primary_photo" do
    assert_difference('PrimaryPhoto.count') do
      post primary_photos_url, params: { primary_photo: {  } }
    end

    assert_redirected_to primary_photo_url(PrimaryPhoto.last)
  end

  test "should show primary_photo" do
    get primary_photo_url(@primary_photo)
    assert_response :success
  end

  test "should get edit" do
    get edit_primary_photo_url(@primary_photo)
    assert_response :success
  end

  test "should update primary_photo" do
    patch primary_photo_url(@primary_photo), params: { primary_photo: {  } }
    assert_redirected_to primary_photo_url(@primary_photo)
  end

  test "should destroy primary_photo" do
    assert_difference('PrimaryPhoto.count', -1) do
      delete primary_photo_url(@primary_photo)
    end

    assert_redirected_to primary_photos_url
  end
end
