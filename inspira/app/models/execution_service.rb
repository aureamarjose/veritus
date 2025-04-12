# frozen_string_literal: true

class ExecutionService < ApplicationRecord
  before_save :convert_number
  belongs_to :service
  belongs_to :list_service

  def convert_number
    self.value = value.gsub(/[^\d,]/, "").gsub(",", ".").to_f
    self.total = total.gsub(/[^\d,]/, "").gsub(",", ".").to_f
  end

  validate :validates_fileds

  private

  def validates_fileds
    # Verifica se algum dos campos está presente
    if [service_date, amount, value, total, list_service_id].any?(&:present?)
      # Se algum campo estiver presente, garante que todos estejam preenchidos
      errors.add(:service_date, "não pode ser em branco.") if service_date.blank?
      errors.add(:amount, "não pode ser em branco.") if amount.blank?
      errors.add(:value, "não pode ser em branco.") if value.blank?
      errors.add(:total, "não pode ser em branco.") if total.blank?
      errors.add(:list_service_id, "não pode ser em branco.") if list_service_id.blank?
    end
  end
end
