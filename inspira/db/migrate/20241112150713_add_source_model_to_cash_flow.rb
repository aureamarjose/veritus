# frozen_string_literal: true

class AddSourceModelToCashFlow < ActiveRecord::Migration[7.1]
  def change
    add_column(:cash_flows, :source_model, :string)
  end
end
