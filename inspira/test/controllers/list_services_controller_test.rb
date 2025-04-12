# frozen_string_literal: true

require "test_helper"

class ListServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @list_service = list_services(:one)
  end

  test "should get index" do
    get list_services_url
    assert_response :success
  end

  test "should get new" do
    get new_list_service_url
    assert_response :success
  end

  test "should create list_service" do
    assert_difference("ListService.count") do
      post list_services_url,
        params: { list_service: { list_delete: @list_service.list_delete, service_name: @list_service.service_name } }
    end

    assert_redirected_to list_service_url(ListService.last)
  end

  test "should show list_service" do
    get list_service_url(@list_service)
    assert_response :success
  end

  test "should get edit" do
    get edit_list_service_url(@list_service)
    assert_response :success
  end

  test "should update list_service" do
    patch list_service_url(@list_service),
      params: { list_service: { list_delete: @list_service.list_delete, service_name: @list_service.service_name } }
    assert_redirected_to list_service_url(@list_service)
  end

  test "should destroy list_service" do
    assert_difference("ListService.count", -1) do
      delete list_service_url(@list_service)
    end

    assert_redirected_to list_services_url
  end
end
