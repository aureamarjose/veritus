# frozen_string_literal: true

class AddAdditionalChargeToCashFlow < ActiveRecord::Migration[7.1]
  def change
    add_reference(:additional_charges, :cash_flow, foreign_key: { to_table: :cash_flows })
  end
end
