# frozen_string_literal: true

class AddBalanceToCashFlow < ActiveRecord::Migration[7.1]
  def change
    add_column(:cash_flows, :balance, :string)
  end
end
