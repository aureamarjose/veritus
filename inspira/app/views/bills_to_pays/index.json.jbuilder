# frozen_string_literal: true

json.array!(@bills_to_pays, partial: "bills_to_pays/bills_to_pay", as: :bills_to_pay)
