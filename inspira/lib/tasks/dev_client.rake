# frozen_string_literal: true

namespace :dev_client do
  desc "Create clients"
  task create_client: :environment do
    show_spinner_client("Criando Clientes ...") do
      15.times do |_i|
        state = ["Física", "Jurídica"].sample # Escolhe aleatoriamente entre Físico e Jurídico

        client = Client.new(
          name_client: state == "Física" ? Faker::Name.name : Faker::Company.name,
          legal_situation: state,
          number_doc: state == "Física" ? Faker::IdNumber.brazilian_citizen_number(formatted: true) : Faker::Company.brazilian_company_number(formatted: true), # rubocop:disable Layout/LineLength
          deleted: 0,
        )

        2.times do |_i|
          client.addresses.build(
            street: Faker::Address.street_name,
            add_number: Faker::Address.building_number,
            neighborhood: Faker::Address.community,
            city: Faker::Address.city,
            uf: Faker::Address.country_code,
            cep: Faker::Address.zip_code,
            deleted: 0,
          )
        end

        2.times do |_i|
          phone_number = Faker::PhoneNumber.cell_phone
          formatted_phone_number = format_phone_number(phone_number)
          client.phones.build(
            phone: formatted_phone_number,
          )
        end

        2.times do |_i|
          client.emails.build(
            email: Faker::Internet.email,
          )
        end

        client.save!
      end
    end
  end

  private

  def show_spinner_client(msg_start, msg_end = "Concluído com sucesso!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :dots_9)
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

  def format_phone_number(phone_number)
    area_code, number = phone_number.split(" ")
    first_part, second_part = number.split("-")
    "#{area_code} #{first_part.insert(1, " ")}-#{second_part}"
  end
end
