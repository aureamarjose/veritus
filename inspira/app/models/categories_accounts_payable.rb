# frozen_string_literal: true

class CategoriesAccountsPayable < ApplicationRecord
  belongs_to :type_of_account,
    foreign_key: "type_account_id",
    class_name: "TypeOfAccount",
    inverse_of: :categories_accounts_payables
  has_many :bills_to_pays, foreign_key: "category_id", dependent: :destroy, inverse_of: :categories_accounts_payable
  accepts_nested_attributes_for :bills_to_pays, allow_destroy: true

  # validates :type_account_id, presence: true
  validates :name, presence: true, length: { maximum: 40 }

  def formatted_name
    "#{type_of_account.name_account} - #{name}"
  end
end
