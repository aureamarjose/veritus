# frozen_string_literal: true

class Received < ApplicationRecord
  before_save :convert_number
  before_save :create_cash_flow_entry
  before_destroy :destroy_cash_flow

  belongs_to :service
  belongs_to :cash_flow, optional: true

  def convert_number
    self.lauch_value = lauch_value.gsub(/[^\d,]/, "").gsub(",", ".").to_f
  end

  validate :lauch_date_validate
  validate :validates_fileds

  private

  # Cria uma entrada no fluxo de caixa se o status for true
  def create_cash_flow_entry
    cash_flow = CashFlow.create!(
      lauch_date: lauch_date,
      lauch_description: release_description,
      lauch_type: "Entrada",
      lauch_value: lauch_value,
      source_model: "received",
    )

    self.cash_flow = cash_flow
  end

  # Exclui a entrada no fluxo de caixa associada
  def destroy_cash_flow
    cash_flow&.destroy
  end

  def validates_fileds
    # Verifica se algum dos campos está presente
    if [lauch_date, release_description, lauch_value].any?(&:present?)
      # Se algum campo estiver presente, garante que todos estejam preenchidos
      errors.add(:lauch_date, "não pode ser em branco.") if lauch_date.blank?
      errors.add(:release_description, "não pode ser em branco.") if release_description.blank?
      errors.add(:lauch_value, "não pode ser em branco.") if lauch_value.blank?
    end
  end

  def lauch_date_validate
    dates = date_ranges
    if lauch_date.present? && lauch_date > dates[:today]
      errors.add(:lauch_date, "não pode ser maior que a data atual.")
    end
  end

  def date_ranges
    tz = TZInfo::Timezone.get("America/Caracas")
    current_time = tz.to_local(Time.current)
    today = current_time.to_date

    {
      today: today,
    }
  end
end
