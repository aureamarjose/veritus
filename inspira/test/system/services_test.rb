# frozen_string_literal: true

require "application_system_test_case"

class ServicesTest < ApplicationSystemTestCase
  setup do
    @service = services(:one)
  end

  test "visiting the index" do
    visit services_url
    assert_selector "h1", text: "Services"
  end

  test "should create service" do
    visit services_url
    click_on "New service"

    fill_in "Clients", with: @service.clients_id
    fill_in "Description", with: @service.description
    fill_in "End date", with: @service.end_date
    fill_in "Financial situation", with: @service.financial_situation
    fill_in "Folder", with: @service.folder
    fill_in "Progress", with: @service.progress
    fill_in "Sector", with: @service.sector
    fill_in "Start date", with: @service.start_date
    click_on "Create Service"

    assert_text "Service was successfully created"
    click_on "Back"
  end

  test "should update Service" do
    visit service_url(@service)
    click_on "Edit this service", match: :first

    fill_in "Clients", with: @service.clients_id
    fill_in "Description", with: @service.description
    fill_in "End date", with: @service.end_date
    fill_in "Financial situation", with: @service.financial_situation
    fill_in "Folder", with: @service.folder
    fill_in "Progress", with: @service.progress
    fill_in "Sector", with: @service.sector
    fill_in "Start date", with: @service.start_date
    click_on "Update Service"

    assert_text "Service was successfully updated"
    click_on "Back"
  end

  test "should destroy Service" do
    visit service_url(@service)
    click_on "Destroy this service", match: :first

    assert_text "Service was successfully destroyed"
  end
end
