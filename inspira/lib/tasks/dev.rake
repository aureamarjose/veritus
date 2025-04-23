# frozen_string_literal: true

namespace :dev do
  desc "Create BD"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando Banco de Dados ...") do
        %x(rails db:drop)
      end

      show_spinner("Criando Banco de Dados ...") do
        %x(rails db:create)
      end

      show_spinner("Migrando Banco de Dados ...") do
        %x(rails db:migrate)
      end

      %x(rails db:seed)

      %x(rake dev_client:create_client)
      %x(rake dev_service:create_list_service)
      %x(rake dev_service:create_service)
      %x(rake dev_bills_to_pay:create_bills_to_pay)
    end
  end

  private

  def show_spinner(msg_start, msg_end = "Concluído com sucesso!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :pulse_2)
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
