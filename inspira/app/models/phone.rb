# frozen_string_literal: true

class Phone < ApplicationRecord
  belongs_to :client

  validate :format_phone

  private

  # Telefone Fixo Cel
  def format_phone
    if phone.blank?
      errors.add(:phone, message: "não pode ficar em branco")
    elsif phone.present? && !phone?
      errors.add(:phone, message: "Formato inválido")
    end
  end

  def phone?
    cel? || fixe?
  end

  def cel?
    /\A\(\d{2}\) \d{1} \d{4}-\d{4}\z/.match?(phone)
  end

  def fixe?
    /\A\(\d{2}\) \d{4}-\d{4}\z/.match?(phone)
  end
end
