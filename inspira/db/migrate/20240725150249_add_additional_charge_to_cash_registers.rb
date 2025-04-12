# frozen_string_literal: true

class AddAdditionalChargeToCashRegisters < ActiveRecord::Migration[7.1]
  def change
    add_reference(:cash_registers, :additional_charge, foreign_key: { to_table: :additional_charges })
  end
end
