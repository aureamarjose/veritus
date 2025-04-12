# frozen_string_literal: true

class RemoveAdditionalChargeIdFromCashRegisters < ActiveRecord::Migration[7.1]
  def change
    remove_column(:cash_registers, :additional_charge_id, :integer)
  end
end
