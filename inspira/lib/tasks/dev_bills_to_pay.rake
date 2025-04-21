# frozen_string_literal: true

namespace :dev_bills_to_pay do
  desc "Create bills to pay"
  task create_bills_to_pay: :environment do
    show_spinner_bills_to_pay("Criando Contas a Pagar ...") do
      bills_to_pay = []
      tz = TZInfo::Timezone.get("America/Caracas") # ou "America/La_Paz"
      current_time = tz.to_local(Time.current)
      current_date = current_time.to_date

      24.times do |i|
        is_current_or_previous_month = i == 0 || i == 1

        start_date = (current_date - i.months).change(day: 9)
        end_date = (current_date - i.months).change(day: 10)
        bill_date = Faker::Date.between(from: start_date, to: end_date)
        bills_to_pay << {
          description: "Aluguel",
          expiration_date: bill_date,
          value: 1500,
          status: !is_current_or_previous_month,
          pay_day: is_current_or_previous_month ? nil : bill_date,
          category_id: 2,
        }
      end

      24.times do |i|
        is_current_or_previous_month = i == 0 || i == 1

        start_date = (current_date - i.months).change(day: 3)
        end_date = (current_date - i.months).change(day: 7)
        bill_date = Faker::Date.between(from: start_date, to: end_date)
        bills_to_pay << {
          description: "Salário",
          expiration_date: bill_date,
          value: 3000,
          status: !is_current_or_previous_month,
          pay_day: is_current_or_previous_month ? nil : bill_date,
          category_id: 1,
        }
      end

      24.times do |i|
        is_current_or_previous_month = i == 0 || i == 1

        start_date = (current_date - i.months).change(day: 10)
        end_date = (current_date - i.months).change(day: 12)
        bill_date = Faker::Date.between(from: start_date, to: end_date)
        bills_to_pay << {
          description: "Energisa",
          expiration_date: bill_date,
          value: 400,
          status: !is_current_or_previous_month,
          pay_day: is_current_or_previous_month ? nil : bill_date,
          category_id: 3,
        }
      end

      24.times do |i|
        is_current_or_previous_month = i == 0 || i == 1

        start_date = (current_date - i.months).change(day: 15)
        end_date = (current_date - i.months).change(day: 17)
        bill_date = Faker::Date.between(from: start_date, to: end_date)
        bills_to_pay << {
          description: "Águas Guariroba",
          expiration_date: bill_date,
          value: 150,
          status: !is_current_or_previous_month,
          pay_day: is_current_or_previous_month ? nil : bill_date,
          category_id: 2,
        }
      end

      24.times do |i|
        is_current_or_previous_month = i == 0 || i == 1

        start_date = (current_date - i.months).change(day: 20)
        end_date = (current_date - i.months).change(day: 25)
        bill_date = Faker::Date.between(from: start_date, to: end_date)
        bills_to_pay << {
          description: "Claro",
          expiration_date: bill_date,
          value: 130,
          status: !is_current_or_previous_month,
          pay_day: is_current_or_previous_month ? nil : bill_date,
          category_id: 5,
        }
      end

      bills_to_pay.each do |bill|
        BillsToPay.find_or_create_by!(bill)
      end
    end
  end

  private

  def show_spinner_bills_to_pay(msg_start, msg_end = "Concluído com sucesso!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :dots_9)
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
