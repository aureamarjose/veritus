# frozen_string_literal: true

class CreateExecutionServices < ActiveRecord::Migration[7.1]
  def change
    create_table(:execution_services) do |t|
      t.date(:service_date)
      t.integer(:amount)
      t.string(:value)
      t.string(:total)
      t.references(:service, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
