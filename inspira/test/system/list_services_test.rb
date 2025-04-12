# frozen_string_literal: true

require "application_system_test_case"

class ListServicesTest < ApplicationSystemTestCase
  setup do
    @list_service = list_services(:one)
  end

  test "visiting the index" do
    visit list_services_url
    assert_selector "h1", text: "List services"
  end

  test "should create list service" do
    visit list_services_url
    click_on "New list service"

    check "List delete" if @list_service.list_delete
    fill_in "Service name", with: @list_service.service_name
    click_on "Create List service"

    assert_text "List service was successfully created"
    click_on "Back"
  end

  test "should update List service" do
    visit list_service_url(@list_service)
    click_on "Edit this list service", match: :first

    check "List delete" if @list_service.list_delete
    fill_in "Service name", with: @list_service.service_name
    click_on "Update List service"

    assert_text "List service was successfully updated"
    click_on "Back"
  end

  test "should destroy List service" do
    visit list_service_url(@list_service)
    click_on "Destroy this list service", match: :first

    assert_text "List service was successfully destroyed"
  end
end
