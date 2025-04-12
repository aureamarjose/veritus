# frozen_string_literal: true

class AddClient2ToServices < ActiveRecord::Migration[7.1]
  def change
    add_reference(:services, :exc_client2, foreign_key: { to_table: :clients })
  end
end
