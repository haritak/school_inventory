require 'test_helper'

class ItemPhotosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item_photo = item_photos(:one)
  end

  test "should get index" do
    get item_photos_url
    assert_response :success
  end

  test "should get new" do
    get new_item_photo_url
    assert_response :success
  end

  test "should create item_photo" do
    assert_difference('ItemPhoto.count') do
      post item_photos_url, params: { item_photo: {  } }
    end

    assert_redirected_to item_photo_url(ItemPhoto.last)
  end

  test "should show item_photo" do
    get item_photo_url(@item_photo)
    assert_response :success
  end

  test "should get edit" do
    get edit_item_photo_url(@item_photo)
    assert_response :success
  end

  test "should update item_photo" do
    patch item_photo_url(@item_photo), params: { item_photo: {  } }
    assert_redirected_to item_photo_url(@item_photo)
  end

  test "should destroy item_photo" do
    assert_difference('ItemPhoto.count', -1) do
      delete item_photo_url(@item_photo)
    end

    assert_redirected_to item_photos_url
  end
end
