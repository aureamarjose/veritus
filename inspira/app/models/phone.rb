# frozen_string_literal: true

class Phone < ApplicationRecord
  belongs_to :client

  validate :format_phone

  private

  # Telefone Fixo Cel
  def format_phone
    if phone.blank?
      errors.add(:phone, message: I18n.t('activerecord.attributes.phone.validation.number_blank'))
    elsif phone.present? && !phone?
      errors.add(:phone, message: I18n.t('activerecord.attributes.phone.validation.invalid_format'))
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
