# frozen_string_literal: true

class ListService < ApplicationRecord
  has_many :execution_services, dependent: :destroy
  accepts_nested_attributes_for :execution_services, allow_destroy: true

  validates :service_name, presence: true
end
