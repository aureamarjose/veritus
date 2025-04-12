# frozen_string_literal: true

class CreateEmails < ActiveRecord::Migration[7.1]
  def change
    create_table(:emails) do |t|
      t.string(:email)
      t.references(:client, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
