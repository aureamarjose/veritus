# frozen_string_literal: true

class TypeOfAccount < ApplicationRecord
  has_many :categories_accounts_payables, inverse_of: :type_of_account, dependent: :destroy
  accepts_nested_attributes_for :categories_accounts_payables, allow_destroy: true
end
