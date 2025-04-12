# frozen_string_literal: true

class AddBillsToPayToCashFlow < ActiveRecord::Migration[7.1]
  def change
    add_reference(:bills_to_pays, :cash_flow, foreign_key: { to_table: :cash_flows })
  end
end
