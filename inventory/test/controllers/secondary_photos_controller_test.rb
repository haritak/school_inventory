require 'test_helper'

class SecondaryPhotosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @secondary_photo = secondary_photos(:one)
  end

  test "should get index" do
    get secondary_photos_url
    assert_response :success
  end

  test "should get new" do
    get new_secondary_photo_url
    assert_response :success
  end

  test "should create secondary_photo" do
    assert_difference('SecondaryPhoto.count') do
      post secondary_photos_url, params: { secondary_photo: {  } }
    end

    assert_redirected_to secondary_photo_url(SecondaryPhoto.last)
  end

  test "should show secondary_photo" do
    get secondary_photo_url(@secondary_photo)
    assert_response :success
  end

  test "should get edit" do
    get edit_secondary_photo_url(@secondary_photo)
    assert_response :success
  end

  test "should update secondary_photo" do
    patch secondary_photo_url(@secondary_photo), params: { secondary_photo: {  } }
    assert_redirected_to secondary_photo_url(@secondary_photo)
  end

  test "should destroy secondary_photo" do
    assert_difference('SecondaryPhoto.count', -1) do
      delete secondary_photo_url(@secondary_photo)
    end

    assert_redirected_to secondary_photos_url
  end
end
