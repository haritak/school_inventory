require 'test_helper'

class InvoicePhotosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invoice_photo = invoice_photos(:one)
  end

  test "should get index" do
    get invoice_photos_url
    assert_response :success
  end

  test "should get new" do
    get new_invoice_photo_url
    assert_response :success
  end

  test "should create invoice_photo" do
    assert_difference('InvoicePhoto.count') do
      post invoice_photos_url, params: { invoice_photo: {  } }
    end

    assert_redirected_to invoice_photo_url(InvoicePhoto.last)
  end

  test "should show invoice_photo" do
    get invoice_photo_url(@invoice_photo)
    assert_response :success
  end

  test "should get edit" do
    get edit_invoice_photo_url(@invoice_photo)
    assert_response :success
  end

  test "should update invoice_photo" do
    patch invoice_photo_url(@invoice_photo), params: { invoice_photo: {  } }
    assert_redirected_to invoice_photo_url(@invoice_photo)
  end

  test "should destroy invoice_photo" do
    assert_difference('InvoicePhoto.count', -1) do
      delete invoice_photo_url(@invoice_photo)
    end

    assert_redirected_to invoice_photos_url
  end
end
