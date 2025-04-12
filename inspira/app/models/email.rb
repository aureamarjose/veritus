# frozen_string_literal: true

class Email < ApplicationRecord
  belongs_to :client

  validate :format_email

  # emails
  def format_email
    if email.blank?
      errors.add(:email, message: "não pode ficar em branco")
    elsif email.present? && !email_valid?
      errors.add(:email, message: "inválido.")
    end
  end

  def email_valid?
    /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match?(email)
  end
end
