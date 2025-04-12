# frozen_string_literal: true

class AddOperationalCostToCashFlow < ActiveRecord::Migration[7.1]
  def change
    add_reference(:operational_costs, :cash_flow, foreign_key: { to_table: :cash_flows })
  end
end
