# frozen_string_literal: true

class Service < ApplicationRecord
  belongs_to :client, class_name: "Client"
  belongs_to :exc_client2, class_name: "Client"
  belongs_to :address, class_name: "Address", optional: true

  has_many :execution_services, dependent: :destroy
  accepts_nested_attributes_for :execution_services, allow_destroy: true

  has_many :additional_charges, dependent: :destroy
  accepts_nested_attributes_for :additional_charges, allow_destroy: true

  has_many :operational_costs, dependent: :destroy
  accepts_nested_attributes_for :operational_costs, allow_destroy: true

  has_many :receiveds, dependent: :destroy
  accepts_nested_attributes_for :receiveds, allow_destroy: true

  before_save :convert_number

  validate :form_folder
  validates :sector, presence: true
  validates :start_date, presence: true
  validates :progress, presence: true

  class << self
    def search2(search)
      Rails.logger.debug("search: #{search}")
      where("folder LIKE :search", search: "%#{search}%")
    end
  end

  scope :by_folder, ->(folder) { where(folder: folder) if folder.present? }

  scope :by_name_contractor, ->(name_contractor) {
    if name_contractor.present?
      name_contractor = name_contractor.downcase
      where("LOWER(client1.name_client) LIKE :name ", name: "%#{name_contractor}%")
    end
  }

  scope :by_client_name, ->(client_name) {
    if client_name.present?
      client_name = client_name.downcase
      where("LOWER(client2.name_client) LIKE :name", name: "%#{client_name}%")
    end
  }

  scope :by_street, ->(street) {
    if street.present?
      street = street.downcase
      joins(:address).where("LOWER(addresses.street) LIKE ?", "%#{street}%")
    end
  }

  scope :by_financial_situation, ->(situation) { where(financial_situation: situation) if situation.present? }

  scope :by_progress, ->(progress) { where(progress: progress) if progress.present? }

  scope :ordered_by_folder, -> { order(Arel.sql("CAST(services.folder AS UNSIGNED) DESC")) }

  private

  def convert_number
    # Garante que `folder` seja uma string e remove pontos, vírgulas e outros caracteres não numéricos
    self.folder = folder.to_s.gsub(/[^\d]/, "").to_i
  end

  def form_folder
    if folder.blank?
      errors.add(:folder, "campo obrigatório")
      return
    end

    # Converte folder removendo separadores e transformando em inteiro
    self.folder = folder.to_s.delete('.').delete(',').to_i

    if Service.where.not(id: id).exists?(folder: folder)
      errors.add(:folder, "já cadastrada")
    elsif folder.to_i.zero?
      errors.add(:folder, "não pode ter o número zero")
    end
  end
end
