# frozen_string_literal: true

require "test_helper"

module AdminsBackoffice
  class WelcomeControllerTest < ActionDispatch::IntegrationTest
    test "should get index" do
      get admins_backoffice_welcome_index_url
      assert_response :success
    end
  end
end
