# frozen_string_literal: true

require "application_system_test_case"

class CategoriesAccountsPayablesTest < ApplicationSystemTestCase
  setup do
    @categories_accounts_payable = categories_accounts_payables(:one)
  end

  test "visiting the index" do
    visit categories_accounts_payables_url
    assert_selector "h1", text: "Categories accounts payables"
  end

  test "should create categories accounts payable" do
    visit categories_accounts_payables_url
    click_on "New categories accounts payable"

    fill_in "Name", with: @categories_accounts_payable.name
    fill_in "Type", with: @categories_accounts_payable.type
    click_on "Create Categories accounts payable"

    assert_text "Categories accounts payable was successfully created"
    click_on "Back"
  end

  test "should update Categories accounts payable" do
    visit categories_accounts_payable_url(@categories_accounts_payable)
    click_on "Edit this categories accounts payable", match: :first

    fill_in "Name", with: @categories_accounts_payable.name
    fill_in "Type", with: @categories_accounts_payable.type
    click_on "Update Categories accounts payable"

    assert_text "Categories accounts payable was successfully updated"
    click_on "Back"
  end

  test "should destroy Categories accounts payable" do
    visit categories_accounts_payable_url(@categories_accounts_payable)
    click_on "Destroy this categories accounts payable", match: :first

    assert_text "Categories accounts payable was successfully destroyed"
  end
end
