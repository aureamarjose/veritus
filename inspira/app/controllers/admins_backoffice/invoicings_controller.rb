# frozen_string_literal: true

module AdminsBackoffice
  class InvoicingsController < ApplicationController
    before_action :authenticate_admin!
    before_action :who_is_logged
    layout "admins_backoffice"
    before_action :group_by_month, only: [:index]
    before_action :years_records, only: [:index]
    before_action :services_executed, only: [:index]

    def index
      render("invoicings/index")
    end

    private

    def who_is_logged
      @logger = true
    end

    def group_by_month
      # parametros do filtro
      @year = params[:year]&.to_i || Date.current.year
      start_date = Date.new(@year, 1, 1)
      end_date = Date.new(@year, 12, 31)

      # Valor Recebido agrupado por mês
      @received = Received.where(lauch_date: start_date..end_date).group_by_month(
        :lauch_date,
        format: "%Y-%b",
      ).sum(:lauch_value)

      # Valor anual
      @received_year = Received.where(lauch_date: start_date..end_date).sum(:lauch_value)

      # IDs das categorias de custo fixo e variável
      fixed_costs_category_ids = CategoriesAccountsPayable.joins(:type_of_account)
        .where(
          type_of_accounts: { name_account: "Custo fixo" },
        ).pluck(:id)
      variable_costs_category_ids = CategoriesAccountsPayable.joins(:type_of_account)
        .where(
          type_of_accounts: { name_account: "Custo variável" },
        ).pluck(:id)

      # custo fixo
      @fixed_costs = BillsToPay.where(
        pay_day: start_date..end_date,
        status: true,
        category_id: fixed_costs_category_ids,
      ).group_by_month(
        :pay_day,
        format: "%Y-%b",
      ).sum(:value)

      # custo fixo anual
      @fixed_costs_year = BillsToPay.where(
        pay_day: start_date..end_date,
        status: true,
        category_id: fixed_costs_category_ids,
      ).sum(:value)

      # custo variável
      @variable_costs = BillsToPay.where(
        pay_day: start_date..end_date,
        status: true,
        category_id: variable_costs_category_ids,
      ).group_by_month(
        :pay_day,
        format: "%Y-%b",
      ).sum(:value)

      # custo variável anual
      @variable_costs_year = BillsToPay.where(
        pay_day: start_date..end_date,
        status: true,
        category_id: variable_costs_category_ids,
      ).sum(:value)

      # Dados de Custos Operacionais
      @operational_costs = OperationalCost.where(
        lauch_date: start_date..end_date,
      ).group_by_month(
        :lauch_date,
        format: "%Y-%b",
      ).sum(:lauch_value)

      # custos operacionais anual
      @operational_costs_year = OperationalCost.where(
        lauch_date: start_date..end_date,
      ).sum(:lauch_value)

      # Dados de Custos Adicionais
      @additional_charges = AdditionalCharge.where(
        lauch_date: start_date..end_date,
      ).group_by_month(
        :lauch_date,
        format: "%Y-%b",
      ).sum(:lauch_value)

      # custos adicionais anual
      @additional_charges_year = AdditionalCharge.where(
        lauch_date: start_date..end_date,
      ).sum(:lauch_value)

      # contas pagas
      bills_to_pay = BillsToPay.where(
        pay_day: start_date..end_date,
        status: true,
      ).group_by_month(
        :pay_day,
        format: "%Y-%b",
      ).sum(:value)

      # Custos
      costs = @additional_charges.merge(@operational_costs) do |_key, additional_charges_data, operational_costs|
        additional_charges_data.to_f + operational_costs.to_f
      end.merge(bills_to_pay) do |_key, combined_costs, bills_paid|
        combined_costs.to_f + bills_paid.to_f
      end

      # custos anual
      @costs_year =
        @additional_charges_year.to_f + @operational_costs_year.to_f +
        @fixed_costs_year.to_f + @variable_costs_year.to_f

      if @received.empty?
        @received = costs.transform_values { 0.0 }
      end

      # lucro líquido
      @profit = {}

      # Iterar sobre cada chave em costs
      costs.each do |key, cost_value|
        received = @received[key].to_f
        cost = cost_value.to_f

        @profit[key] = if received.zero? && cost > 0
          -cost
        else
          received - cost
        end
      end

      # lucro líquido anual
      @profit_year = @received_year.to_f - @costs_year.to_f
      previous_year

      # Saldo Final
      # Inicializar o saldo final com o valor de janeiro
      end_balance = {}
      months = ["jan", "fev", "mar", "abr", "mai", "jun", "jul", "ago", "set", "out", "nov", "dez"]
      previous_balance = @previous_balance.to_f

      # Calcular o saldo final para cada mês
      months.each_with_index do |month, _index|
        month_key = "#{@year}-#{month}"
        previous_balance += @profit[month_key].to_f if @profit[month_key]
        end_balance[month_key] = previous_balance
      end

      @end_balance = end_balance

      # Saldo Inicial
      # Inicializar o saldo inicial com o valor de janeiro
      initial_balance = {}
      previous_balance_2 = @previous_balance.to_f

      # Definir o saldo inicial para janeiro
      initial_balance["#{@year}-jan"] = previous_balance_2

      # Calcular o saldo inicial para os meses subsequentes
      months[1..-1].each_with_index do |month, index|
        previous_month_key = "#{@year}-#{months[index]}"
        current_month_key = "#{@year}-#{month}"
        previous_balance_2 += @profit[previous_month_key].to_f if @profit[previous_month_key]
        initial_balance[current_month_key] = previous_balance_2
      end

      @inicial_balance = initial_balance

      # calcular o percentual de cada custo em relação ao faturamento
      @fixed_cost_percentage =
        @received_year.to_f.zero? ? 0 : (@fixed_costs_year.to_f / @received_year.to_f) * 100
      @variable_cost_percentage =
        @received_year.to_f.zero? ? 0 : (@variable_costs_year.to_f / @received_year.to_f) * 100
      @operational_cost_percentage =
        @received_year.to_f.zero? ? 0 : (@operational_costs_year.to_f / @received_year.to_f) * 100
      @additional_charge_percentage =
        @received_year.to_f.zero? ? 0 : (@additional_charges_year.to_f / @received_year.to_f) * 100
      @profit_year_percentage =
        @received_year.to_f.zero? ? 0 : (@profit_year.to_f / @received_year.to_f) * 100

      # Custos anual
      @annual_revenue = {}
      @annual_revenue["Custo Fixo"] = @fixed_cost_percentage if @fixed_cost_percentage != 0
      @annual_revenue["Custo Variável"] =
        @variable_cost_percentage if @variable_cost_percentage != 0
      @annual_revenue["Custo Operacional"] =
        @operational_cost_percentage if @operational_cost_percentage != 0
      @annual_revenue["Custo Adicional"] =
        @additional_charge_percentage if @additional_charge_percentage != 0
      @annual_revenue["Lucro"] = @profit_year_percentage if @profit_year_percentage != 0
    end

    def previous_year
      # Verificar se há dados dos anos anteriores
      previous_year = @year - 1
      previous_year_end_date = Date.new(previous_year, 12, 31)
      previous_year_start_date = -Float::INFINITY

      # recebimnetos
      previous_year_received = Received.where(
        lauch_date: previous_year_start_date..previous_year_end_date,
      ).sum(:lauch_value)

      # pagamentos
      previous_year_bills_to_pays = BillsToPay.where(
        pay_day: previous_year_start_date..previous_year_end_date,
        status: true,
      ).sum(:value)

      # custos operacionais
      previous_year_operational_costs = OperationalCost.where(
        lauch_date: previous_year_start_date..previous_year_end_date,
      ).sum(:lauch_value)

      # custos adicionais
      previous_year_additional_charges = AdditionalCharge.where(
        lauch_date: previous_year_start_date..previous_year_end_date,
      ).sum(:lauch_value)

      # Total dos custos
      previous_year_total_costs = previous_year_bills_to_pays.to_f +
        previous_year_operational_costs.to_f +
        previous_year_additional_charges.to_f

      # lucro líquido
      previous_year_balance = previous_year_received.to_f - previous_year_total_costs.to_f

      # Adicionar saldo inicial ao mês de janeiro
      if previous_year_balance != 0
        @previous_balance = previous_year_balance
      end
    end

    # Registro Anual
    def years_records
      dates = date_ranges
      @years_records = []
      @current_year = dates[:current_time].year

      # Consultar todos os anos distintos de Received, BillsToPay, OperationalCost, AdditionalCharge e CashFlow
      received_years = Received.where.not(lauch_date: nil).pluck(Arel.sql("DISTINCT EXTRACT(YEAR FROM lauch_date)")).map(&:to_i)
      bills_to_pay_years = BillsToPay.where.not(pay_day: nil).pluck(Arel.sql("DISTINCT EXTRACT(YEAR FROM pay_day)")).map(&:to_i)
      operational_cost_years = OperationalCost.where.not(lauch_date: nil).pluck(Arel.sql("DISTINCT EXTRACT(YEAR FROM lauch_date)")).map(&:to_i)
      additional_charge_years = AdditionalCharge.where.not(lauch_date: nil).pluck(Arel.sql("DISTINCT EXTRACT(YEAR FROM lauch_date)")).map(&:to_i)
      cash_flow_years = CashFlow.where.not(lauch_date: nil).pluck(Arel.sql("DISTINCT EXTRACT(YEAR FROM lauch_date)")).map(&:to_i)

      # Unir todos os anos distintos e remover duplicatas
      @years_records = (received_years + bills_to_pay_years + operational_cost_years + additional_charge_years + cash_flow_years).uniq

      # Ordenar os anos em ordem decrescente
      @years_records.sort! { |a, b| b <=> a }
    end

    # Serviço executados
    # Estrutura de dados para armazenar os resultados dos serviços
    ServiceData = Struct.new(
      :list_service_id,
      :service_name,
      :service_count,
      :total_sum,
      :operational_cost,
      :net_value,
      :percentage_of_total,
    )

    def services_executed
      start_date = Date.new(@year, 1, 1)
      end_date = Date.new(@year, 12, 31)

      # Calcular a soma de lauch_value por list_service_id dentro do intervalo de datas
      operational_costs = OperationalCost
        .where(lauch_date: start_date..end_date)
        .group(:list_service_id)
        .sum(:lauch_value)

      # Agrupar serviços executados por período de um ano e trazer o nome de cada serviço
      @services = ExecutionService.joins(:list_service)
        .where(service_date: start_date..end_date)
        .group("execution_services.list_service_id", "list_services.service_name")
        .select("execution_services.list_service_id, list_services.service_name, COUNT(execution_services.id) as service_count,
          SUM(execution_services.total) as total_sum")

      @total_sum = @services.sum { |service| service.total_sum.to_f }
      # Adicionar custos operacionais, valor líquido e percentual aos resultados usando Struct
      @services = @services.map do |service|
        operational_cost = operational_costs[service.list_service_id] || 0
        net_value = service.total_sum.to_f - operational_cost.to_f
        percentage_of_total = @total_sum > 0 ? (service.total_sum.to_f / @total_sum) * 100 : 0
        ServiceData.new(
          service.list_service_id,
          service.service_name,
          service.service_count,
          service.total_sum.to_f,
          operational_cost.to_f,
          net_value,
          percentage_of_total,
        )
      end

      @service_data_for_chart = @services.each_with_object({}) do |service, hash|
        hash[service.service_name] = service.percentage_of_total
      end

      # Calcular totais
      @total_service_count = @services.sum { |service| service.service_count.to_i }

      @total_operational_cost = @services.sum { |service| service.operational_cost.to_f }
      @total_net_value = @services.sum { |service| service.net_value.to_f }
    end
  end
end
