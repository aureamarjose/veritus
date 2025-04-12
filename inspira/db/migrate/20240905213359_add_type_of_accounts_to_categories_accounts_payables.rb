# frozen_string_literal: true

class AddTypeOfAccountsToCategoriesAccountsPayables < ActiveRecord::Migration[7.1]
  def change
    add_reference(:categories_accounts_payables, :type_account, foreign_key: { to_table: :type_of_accounts })
  end
end
