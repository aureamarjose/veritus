# frozen_string_literal: true

require "application_system_test_case"

class BillsToPaysTest < ApplicationSystemTestCase
  setup do
    @bills_to_pay = bills_to_pays(:one)
  end

  test "visiting the index" do
    visit bills_to_pays_url
    assert_selector "h1", text: "Bills to pays"
  end

  test "should create bills to pay" do
    visit bills_to_pays_url
    click_on "New bills to pay"

    check "Deleted" if @bills_to_pay.deleted
    fill_in "Description", with: @bills_to_pay.description
    fill_in "Expiration date", with: @bills_to_pay.expiration_date
    fill_in "Status", with: @bills_to_pay.status
    fill_in "Value", with: @bills_to_pay.value
    click_on "Create Bills to pay"

    assert_text "Bills to pay was successfully created"
    click_on "Back"
  end

  test "should update Bills to pay" do
    visit bills_to_pay_url(@bills_to_pay)
    click_on "Edit this bills to pay", match: :first

    check "Deleted" if @bills_to_pay.deleted
    fill_in "Description", with: @bills_to_pay.description
    fill_in "Expiration date", with: @bills_to_pay.expiration_date
    fill_in "Status", with: @bills_to_pay.status
    fill_in "Value", with: @bills_to_pay.value
    click_on "Update Bills to pay"

    assert_text "Bills to pay was successfully updated"
    click_on "Back"
  end

  test "should destroy Bills to pay" do
    visit bills_to_pay_url(@bills_to_pay)
    click_on "Destroy this bills to pay", match: :first

    assert_text "Bills to pay was successfully destroyed"
  end
end
