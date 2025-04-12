# frozen_string_literal: true

class CreateTypeOfAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table(:type_of_accounts) do |t|
      t.string(:name_account)

      t.timestamps
    end
  end
end
