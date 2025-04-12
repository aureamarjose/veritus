# frozen_string_literal: true

require "test_helper"

class BillsToPaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bills_to_pay = bills_to_pays(:one)
  end

  test "should get index" do
    get bills_to_pays_url
    assert_response :success
  end

  test "should get new" do
    get new_bills_to_pay_url
    assert_response :success
  end

  test "should create bills_to_pay" do
    assert_difference("BillsToPay.count") do
      post bills_to_pays_url,
        params: {
          bills_to_pay: {
            deleted: @bills_to_pay.deleted,
            description: @bills_to_pay.description,
            expiration_date: @bills_to_pay.expiration_date,
            status: @bills_to_pay.status,
            value: @bills_to_pay.value,
          },
        }
    end

    assert_redirected_to bills_to_pay_url(BillsToPay.last)
  end

  test "should show bills_to_pay" do
    get bills_to_pay_url(@bills_to_pay)
    assert_response :success
  end

  test "should get edit" do
    get edit_bills_to_pay_url(@bills_to_pay)
    assert_response :success
  end

  test "should update bills_to_pay" do
    patch bills_to_pay_url(@bills_to_pay),
      params: {
        bills_to_pay: {
          deleted: @bills_to_pay.deleted,
          description: @bills_to_pay.description,
          expiration_date: @bills_to_pay.expiration_date,
          status: @bills_to_pay.status,
          value: @bills_to_pay.value,
        },
      }
    assert_redirected_to bills_to_pay_url(@bills_to_pay)
  end

  test "should destroy bills_to_pay" do
    assert_difference("BillsToPay.count", -1) do
      delete bills_to_pay_url(@bills_to_pay)
    end

    assert_redirected_to bills_to_pays_url
  end
end
