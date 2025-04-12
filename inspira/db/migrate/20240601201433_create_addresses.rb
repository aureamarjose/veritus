# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table(:addresses) do |t|
      t.string(:neighborhood)
      t.string(:street)
      t.string(:city)
      t.string(:cep)
      t.string(:uf)
      t.string(:complement)
      t.references(:client, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
