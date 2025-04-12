# frozen_string_literal: true

class OperationalCost < ApplicationRecord
  before_save :convert_number
  before_save :create_cash_flow_entry
  before_destroy :destroy_cash_flow

  belongs_to :service
  belongs_to :cash_flow, optional: true

  def convert_number
    self.lauch_value = lauch_value.gsub(/[^\d,]/, "").gsub(",", ".").to_f
  end

  validate :validates_fileds

  private

  def validates_fileds
    # Verifica se algum dos campos está presente
    if [lauch_date, release_description, lauch_value, list_service_id].any?(&:present?)
      # Se algum campo estiver presente, garante que todos estejam preenchidos
      errors.add(:lauch_date, "não pode ser em branco.") if lauch_date.blank?
      errors.add(:release_description, "não pode ser em branco.") if release_description.blank?
      errors.add(:lauch_value, "não pode ser em branco.") if lauch_value.blank?
      errors.add(:list_service_id, "não pode ser em branco.") if list_service_id.blank?
    end
  end

  # Cria uma entrada no fluxo de caixa se o status for true
  def create_cash_flow_entry
    cash_flow = CashFlow.create!(
      lauch_date: lauch_date,
      lauch_description: release_description,
      lauch_type: "Saída",
      lauch_value: lauch_value,
      source_model: "operational_cost",
    )

    self.cash_flow = cash_flow
  end

  # Exclui a conta no fluxo de caixa associada
  def destroy_cash_flow
    cash_flow&.destroy
  end
end
