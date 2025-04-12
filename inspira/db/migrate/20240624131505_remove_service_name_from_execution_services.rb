# frozen_string_literal: true

class RemoveServiceNameFromExecutionServices < ActiveRecord::Migration[7.1]
  def change
    remove_column(:execution_services, :service_name, :string)
  end
end
