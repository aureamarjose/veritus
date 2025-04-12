# frozen_string_literal: true

class BillsToPay < ApplicationRecord
  before_save :convert_number
  before_save :create_cash_flow_entry, if: :status_true?
  before_destroy :destroy_cash_flow

  belongs_to :categories_accounts_payable,
    foreign_key: "category_id",
    class_name: "CategoriesAccountsPayable",
    inverse_of: :bills_to_pays
  belongs_to :cash_flow, optional: true

  validates :description, presence: true
  validates :expiration_date, presence: true
  validates :value, presence: true
  validate :status_cannot_be_blank
  validate :pay_day_must_be_present_if_status_is_true

  # filtro
  scope :not_paid, -> { where(status: false) }
  scope :current_month, -> { where(expiration_date: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month) }
  scope :previous_month, -> { where(expiration_date: 1.month.ago.beginning_of_month..1.month.ago.end_of_month) }
  scope :next_month, -> { where(expiration_date: 1.month.from_now.beginning_of_month..1.month.from_now.end_of_month) }
  scope :filter_by_account, ->(account_type_name) {
    joins(categories_accounts_payable: :type_of_account).where(type_of_accounts: { name_account: account_type_name })
  }
  scope :by_pay_day, ->(start_date, end_date) { where(pay_day: start_date..end_date) }
  scope :by_expiration_date, ->(start_date, end_date) { where(expiration_date: start_date..end_date) }
  scope :by_category, ->(category) { where(category_id: category) }
  scope :by_status, ->(status) { where(status: status) }

  private

  def status_cannot_be_blank
    if status.nil?
      errors.add(:status, "selecione uma opção")
    end
  end

  def pay_day_must_be_present_if_status_is_true
    dates = date_ranges
    if status == true && pay_day.blank?
      errors.add(:pay_day, "é obrigatório.")
    elsif pay_day.present? && pay_day > dates[:today]
      errors.add(:pay_day, "não pode ser maior que a data atual.")
    end
  end

  def convert_number
    self.value = value.gsub(/[^\d,]/, "").gsub(",", ".").to_f
  end

  # Verifica se o status é true
  def status_true?
    status == true
  end

  # Cria uma entrada no fluxo de caixa se o status for true
  def create_cash_flow_entry
    return unless status_true?

    cash_flow = CashFlow.create!(
      lauch_date: pay_day,
      lauch_description: description,
      lauch_type: "Saída",
      lauch_value: value,
      source_model: "bills_to_pay",
    )

    self.cash_flow = cash_flow
  end

  # Exclui a conta no fluxo de caixa associada
  def destroy_cash_flow
    cash_flow&.destroy
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
