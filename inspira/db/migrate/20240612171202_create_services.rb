# frozen_string_literal: true

class CreateServices < ActiveRecord::Migration[7.1]
  def change
    create_table(:services) do |t|
      t.string(:folder)
      t.string(:sector)
      t.date(:start_date)
      t.date(:end_date)
      t.string(:financial_situation)
      t.string(:progress)
      t.string(:description)
      t.references(:client, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
