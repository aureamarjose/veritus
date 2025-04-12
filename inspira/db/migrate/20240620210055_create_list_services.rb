# frozen_string_literal: true

class CreateListServices < ActiveRecord::Migration[7.1]
  def change
    create_table(:list_services) do |t|
      t.string(:service_name)
      t.boolean(:list_delete)

      t.timestamps
    end
  end
end
