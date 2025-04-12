# frozen_string_literal: true

class AddServiceNameToExecutionServices < ActiveRecord::Migration[7.1]
  def change
    add_column(:execution_services, :service_name, :string)
  end
end
