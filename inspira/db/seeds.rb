# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admins = ["admin@admin.com", "inspira.arquiegeo@gmail.com"]

show_spinner("Criando Admins e Users ...") do
  admins.each do |email|
    next if Admin.find_by(email: email)

    Admin.create!(
      email: email,
      name: "Administrador",
      password: "asdasd",
      password_confirmation: "asdasd",
    )
  end
end

if Rails.env.production?
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

show_spinner("Criando tipos de custos ...") do
  ["Custo fixo", "Custo variável"].each do |name|
    TypeOfAccount.find_or_create_by!(name_account: name)
  end

  accounts = [
    {
      name: "Salário",
      type_account_id: TypeOfAccount.find_by(name_account: "Custo fixo").id,
    },
    {
      name: "Aluguel",
      type_account_id: TypeOfAccount.find_by(name_account: "Custo fixo").id,
    },
    {
      name: "Luz",
      type_account_id: TypeOfAccount.find_by(name_account: "Custo fixo").id,
    },
    {
      name: "Água",
      type_account_id: TypeOfAccount.find_by(name_account: "Custo fixo").id,
    },
    {
      name: "Telefone / internet",
      type_account_id: TypeOfAccount.find_by(name_account: "Custo fixo").id,
    },
    {
      name: "Despesas bancárias",
      type_account_id: TypeOfAccount.find_by(name_account: "Custo fixo").id,
    },
    {
      name: "Material de escritório",
      type_account_id: TypeOfAccount.find_by(name_account: "Custo variável").id,
    },
    {
      name: "Equipamentos e acessórios",
      type_account_id: TypeOfAccount.find_by(name_account: "Custo variável").id,
    },
    {
      name: "Despesas com transporte e deslocamento",
      type_account_id: TypeOfAccount.find_by(name_account: "Custo variável").id,
    },
    {
      name: "Despesas com tecnologia",
      type_account_id: TypeOfAccount.find_by(name_account: "Custo variável").id,
    },
    {
      name: "Despesas com alimentação",
      type_account_id: TypeOfAccount.find_by(name_account: "Custo variável").id,
    },
    {
      name: "Eventos e treinamentos",
      type_account_id: TypeOfAccount.find_by(name_account: "Custo variável").id,
    },
    {
      name: "Manutenção de equipamentos",
      type_account_id: TypeOfAccount.find_by(name_account: "Custo variável").id,
    },
    {
      name: "Outros imprevistos",
      type_account_id: TypeOfAccount.find_by(name_account: "Custo variável").id,
    },
  ]

  accounts.each do |account|
    CategoriesAccountsPayable.find_or_create_by!(account)
  end
end

private

def show_spinner(msg_start, msg_end = "Concluído com sucesso!")
  spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :pulse_2)
  spinner.auto_spin
  yield
  spinner.success("(#{msg_end})")
end
