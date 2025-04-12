# frozen_string_literal: true

class CreateCashRegisters < ActiveRecord::Migration[7.1]
  def change
    create_table(:cash_registers, &:timestamps)
  end
end
