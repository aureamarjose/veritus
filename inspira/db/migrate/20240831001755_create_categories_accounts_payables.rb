# frozen_string_literal: true

class CreateCategoriesAccountsPayables < ActiveRecord::Migration[7.1]
  def change
    create_table(:categories_accounts_payables) do |t|
      t.string(:type)
      t.string(:name)

      t.timestamps
    end
  end
end
