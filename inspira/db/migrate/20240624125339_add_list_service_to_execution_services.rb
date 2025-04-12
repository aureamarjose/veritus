# frozen_string_literal: true

class AddListServiceToExecutionServices < ActiveRecord::Migration[7.1]
  def change
    add_reference(:execution_services, :list_service, foreign_key: { to_table: :list_services })
  end
end
