# frozen_string_literal: true

class CreateBillsToPays < ActiveRecord::Migration[7.1]
  def change
    create_table(:bills_to_pays) do |t|
      t.string(:description)
      t.date(:expiration_date)
      t.string(:value)
      t.boolean(:status)
      t.date(:pay_day)
      t.boolean(:deleted)

      t.timestamps
    end
  end
end
