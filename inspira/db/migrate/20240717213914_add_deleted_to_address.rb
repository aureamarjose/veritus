# frozen_string_literal: true

class AddDeletedToAddress < ActiveRecord::Migration[7.1]
  def change
    add_column(:addresses, :deleted, :boolean)
  end
end
