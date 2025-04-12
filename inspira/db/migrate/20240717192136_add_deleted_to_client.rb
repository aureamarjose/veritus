# frozen_string_literal: true

class AddDeletedToClient < ActiveRecord::Migration[7.1]
  def change
    add_column(:clients, :deleted, :boolean)
  end
end
