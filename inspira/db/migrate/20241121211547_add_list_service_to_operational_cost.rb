# frozen_string_literal: true

class AddListServiceToOperationalCost < ActiveRecord::Migration[7.1]
  def change
    add_reference(:operational_costs, :list_service, foreign_key: { to_table: :list_services })
  end
end
