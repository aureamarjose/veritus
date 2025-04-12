# frozen_string_literal: true

json.array!(
  @categories_accounts_payables,
  partial: "categories_accounts_payables/categories_accounts_payable",
  as: :categories_accounts_payable,
)
