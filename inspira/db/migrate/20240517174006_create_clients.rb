# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table(:clients) do |t|
      t.string(:name_client)
      t.string(:legal_situation)
      t.string(:number_doc)

      t.timestamps
    end
  end
end
