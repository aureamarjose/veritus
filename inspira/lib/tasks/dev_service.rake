# frozen_string_literal: true

namespace :dev_service do
  desc "Create clients"
  task create_list_service: :environment do
    show_spinner_service("Criando Lista de Serviços ...") do
      list_services = [
        {
          service_name: "Georreferenciamento",
          list_delete: false,
        },
        {
          service_name: "Topografia",
          list_delete: false,
        },
        {
          service_name: "Desmembramento",
          list_delete: false,
        },
        {
          service_name: "Planta Sigef",
          list_delete: false,
        },
        {
          service_name: "Levantamento Planialtimétrico",
          list_delete: false,
        },
        {
          service_name: "Levantamento Cadastral",
          list_delete: false,
        },
      ]
      list_services.each do |service|
        ListService.find_or_create_by!(service)
      end
    end
  end

  task create_service: :environment do
    show_spinner_service("Criando Serviços ...") do
      folder_number = 1
      50.times do |_i|
        sector = ["Projeto", "Execução", "Rural", "Particular"].sample
        date = Faker::Date.between(from: 2.years.ago, to: 1.day.ago)
        progress = ["Em andamento", "Finalizado"].sample
        description_charges = [
          "Taxa de cartório",
          "Taxa de registro",
          "Taxa de certidão",
          "Reconhecimento de Firma",
        ].sample
        description_costs = [
          "Mão de Obra",
          "Material",
          "Equipamento",
          "Combustível",
        ].sample

        exc_client2 = Client.all.sample
        address = exc_client2.addresses.sample

        # service.execution_services.build
        amount = Faker::Number.between(from: 1, to: 4)
        value = Faker::Number.within(range: 500..2000)
        total = amount * value

        # service.additional_charges
        additional_charge_value = Faker::Number.within(range: 35..200)

        # service.operacional_costs
        operational_cost_value = Faker::Number.within(range: 150..600)

        # service.receiveds
        received_value = total + additional_charge_value

        financial_situation = "Quitado"

        # if folder_number.even?
        #   financial_situation = "Quitado"
        #   received_value
        # else
        #   financial_situation = "Aberto"
        #   received_value -= (received_value / 2)
        # end

        service = Service.new(
          folder: folder_number,
          sector: sector,
          start_date: date,
          progress: progress,
          financial_situation: financial_situation,
          client_id: Client.all.sample.id,
          exc_client2_id: exc_client2.id,
          address_id: address.id,
        )

        2.times do |_i|
          list_service_id = ListService.all.sample.id

          service.execution_services.build(
            service_date: date,
            amount: amount,
            value: value,
            total: total,
            list_service_id: list_service_id,
          )

          service.operational_costs.build(
            lauch_date: date,
            release_description: description_costs,
            list_service_id: list_service_id,
            lauch_value: operational_cost_value,
          )
        end

        2.times do |_i|
          service.additional_charges.build(
            lauch_date: date,
            release_description: description_charges,
            lauch_value: additional_charge_value,
          )
        end

        2.times do |_i|
          service.receiveds.build(
            lauch_date: date,
            release_description: "Recebimento",
            lauch_value: received_value,
          )
        end
        service.save!

        folder_number += 1 # Incrementa o contador
      end
    end
  end

  private

  def show_spinner_service(msg_start, msg_end = "Concluído com sucesso!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :dots_9)
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
