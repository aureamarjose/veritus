# frozen_string_literal: true

class Client < ApplicationRecord
  class << self
    def search(search)
      where(deleted: false).where("name_client LIKE :search OR number_doc LIKE :search", search: "%#{search}%")
    end
  end

  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones, allow_destroy: true

  has_many :emails, dependent: :destroy
  accepts_nested_attributes_for :emails, allow_destroy: true

  # has_many :addresses, inverse_of: :client, dependent: :destroy
  # accepts_nested_attributes_for :addresses, allow_destroy: true
  # No modelo Client
  has_many :addresses, -> { where(deleted: false) }, inverse_of: :client
  accepts_nested_attributes_for :addresses, allow_destroy: true

  has_many :services, dependent: :destroy
  accepts_nested_attributes_for :services, allow_destroy: true

  validates :name_client, presence: true
  validates :legal_situation, presence: true
  validate :format_cpf
  validate :phone_presence
  # validates_associated :phones
  validate :email_presence
  # validates_associated :emails
  # validate :address
  # validates_associated :addresses

  private

  # Cpf Cnpj
  def format_cpf
    if number_doc.blank?
      errors.add(:number_doc, message: I18n.t('activerecord.attributes.client.validation.number_doc_blank'))
    elsif number_doc.present? && !cpf_cnpj?
      errors.add(:number_doc, message: I18n.t('activerecord.attributes.client.validation.invalid_format'))
    end
  end

  def cpf_cnpj?
    cpf? || cnpj?
  end

  def cpf?
    /\A\d{3}\.\d{3}\.\d{3}-\d{2}\z/.match?(number_doc)
  end

  def cnpj?
    %r{\A\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}\z}.match?(number_doc)
  end

  def phone_presence
    if phones.blank? || phones.all?(&:marked_for_destruction?)
      errors.add(:phones, I18n.t('activerecord.attributes.phone.validation.present_validation'))
    end
  end

  def email_presence
    if emails.blank? || emails.all?(&:marked_for_destruction?)
      errors.add(:emails, I18n.t('activerecord.attributes.email.validation.present_validation'))
    end
  end

  def address
    if addresses.blank? || addresses.all?(&:marked_for_destruction?)
      errors.add(:addresses, I18n.t('activerecord.attributes.address.validation.present_validation'))
    end
  end
end
