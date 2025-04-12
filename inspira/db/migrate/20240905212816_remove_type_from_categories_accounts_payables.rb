# frozen_string_literal: true

class RemoveTypeFromCategoriesAccountsPayables < ActiveRecord::Migration[7.1]
  def change
    remove_column(:categories_accounts_payables, :type, :string)
  end
end
