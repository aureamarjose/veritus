# frozen_string_literal: true

require "test_helper"

class CategoriesAccountsPayablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @categories_accounts_payable = categories_accounts_payables(:one)
  end

  test "should get index" do
    get categories_accounts_payables_url
    assert_response :success
  end

  test "should get new" do
    get new_categories_accounts_payable_url
    assert_response :success
  end

  test "should create categories_accounts_payable" do
    assert_difference("CategoriesAccountsPayable.count") do
      post categories_accounts_payables_url,
        params: {
          categories_accounts_payable: {
            name: @categories_accounts_payable.name,
            type: @categories_accounts_payable.type,
          },
        }
    end

    assert_redirected_to categories_accounts_payable_url(CategoriesAccountsPayable.last)
  end

  test "should show categories_accounts_payable" do
    get categories_accounts_payable_url(@categories_accounts_payable)
    assert_response :success
  end

  test "should get edit" do
    get edit_categories_accounts_payable_url(@categories_accounts_payable)
    assert_response :success
  end

  test "should update categories_accounts_payable" do
    patch categories_accounts_payable_url(@categories_accounts_payable),
      params: {
        categories_accounts_payable: {
          name: @categories_accounts_payable.name,
          type: @categories_accounts_payable.type,
        },
      }
    assert_redirected_to categories_accounts_payable_url(@categories_accounts_payable)
  end

  test "should destroy categories_accounts_payable" do
    assert_difference("CategoriesAccountsPayable.count", -1) do
      delete categories_accounts_payable_url(@categories_accounts_payable)
    end

    assert_redirected_to categories_accounts_payables_url
  end
end
