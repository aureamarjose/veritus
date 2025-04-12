# frozen_string_literal: true

class AddAdressToServices < ActiveRecord::Migration[7.1]
  def change
    add_reference(:services, :address, foreign_key: { to_table: :addresses })
  end
end
