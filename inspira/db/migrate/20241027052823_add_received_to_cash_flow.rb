# frozen_string_literal: true

class AddReceivedToCashFlow < ActiveRecord::Migration[7.1]
  def change
    add_reference(:receiveds, :cash_flow, foreign_key: { to_table: :cash_flows })
  end
end
