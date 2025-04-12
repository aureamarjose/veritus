# frozen_string_literal: true

class CashFlow < ApplicationRecord
  has_many :bills_to_pays, dependent: :destroy
  has_many :receiveds, dependent: :destroy
  has_many :additional_charges, dependent: :destroy
  has_many :operational_costs, dependent: :destroy

  validates :lauch_date, presence: true
  validates :lauch_description, presence: true
  validates :lauch_value, presence: true

  scope :income_entries, -> { where(lauch_type: "Entrada").where.not(source_model: "cash_flow") }
  scope :by_client, ->(name) {
    joins(receiveds: { service: :client })
      .where("clients.name_client LIKE ?", "%#{name}%")
  }
  scope :ordered, -> { order(lauch_date: :desc, id: :desc) }
end
