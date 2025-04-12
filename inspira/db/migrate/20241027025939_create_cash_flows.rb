# frozen_string_literal: true

class CreateCashFlows < ActiveRecord::Migration[7.1]
  def change
    create_table(:cash_flows) do |t|
      t.date(:lauch_date)
      t.string(:lauch_description)
      t.string(:lauch_type)
      t.string(:lauch_value)

      t.timestamps
    end
  end
end
