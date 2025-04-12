# frozen_string_literal: true

require "test_helper"

module UsersBackoffice
  class WelcomeControllerTest < ActionDispatch::IntegrationTest
    test "should get index" do
      get users_backoffice_welcome_index_url
      assert_response :success
    end
  end
end
