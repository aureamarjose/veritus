# frozen_string_literal: true

class CreateOperationalCosts < ActiveRecord::Migration[7.1]
  def change
    create_table(:operational_costs) do |t|
      t.date(:lauch_date)
      t.string(:release_description)
      t.string(:lauch_value)
      t.references(:service, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
