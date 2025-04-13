# frozen_string_literal: true

class Email < ApplicationRecord
  belongs_to :client

  validate :format_email

  # emails
  def format_email
    if email.blank?
      errors.add(:email, message: I18n.t('activerecord.attributes.email.validation.email_blank'))
    elsif email.present? && !email_valid?
      errors.add(:email, message: I18n.t('activerecord.attributes.email.validation.invalid_format'))
    end
  end

  def email_valid?
    /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match?(email)
  end
end
