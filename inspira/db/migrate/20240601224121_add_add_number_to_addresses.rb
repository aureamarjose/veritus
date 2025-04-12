# frozen_string_literal: true

class AddAddNumberToAddresses < ActiveRecord::Migration[7.1]
  def change
    add_column(:addresses, :add_number, :string)
  end
end
