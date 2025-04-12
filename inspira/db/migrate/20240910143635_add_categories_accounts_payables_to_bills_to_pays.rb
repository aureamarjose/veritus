# frozen_string_literal: true

class AddCategoriesAccountsPayablesToBillsToPays < ActiveRecord::Migration[7.1]
  def change
    add_reference(:bills_to_pays, :category, foreign_key: { to_table: :categories_accounts_payables })
  end
end
