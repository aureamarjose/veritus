# frozen_string_literal: true

json.extract!(bills_to_pay, :id, :description, :expiration_date, :value, :status, :deleted, :created_at, :updated_at)
json.url(bills_to_pay_url(bills_to_pay, format: :json))
