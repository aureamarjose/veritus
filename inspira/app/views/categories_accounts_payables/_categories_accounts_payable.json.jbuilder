# frozen_string_literal: true

json.extract!(categories_accounts_payable, :id, :type, :name, :created_at, :updated_at)
json.url(categories_accounts_payable_url(categories_accounts_payable, format: :json))
