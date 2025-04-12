# frozen_string_literal: true

class CreatePhones < ActiveRecord::Migration[7.1]
  def change
    create_table(:phones) do |t|
      t.string(:phone)
      t.references(:client, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
