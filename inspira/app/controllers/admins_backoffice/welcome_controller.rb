# frozen_string_literal: true

module AdminsBackoffice
  class WelcomeController < AdminsBackofficeController
    before_action :authenticate_admin!
    before_action :who_is_logged
    layout "admins_backoffice"

    # index additional_charge
    def index
      # A receber serviços de execução
      @services = ExecutionService.all
      @service_total_value = @services.sum { |service| service.total.to_f }

      # custo operacional
      @operacional_costs = OperationalCost.all
      @operational_costs_total_value = @operacional_costs.sum { |cost| cost.lauch_value.to_f }

      # custo adcional para cobrar do cliente
      @additional_charges = AdditionalCharge.all
      @additional_charges_total_value = @additional_charges.sum { |charge| charge.lauch_value.to_f }

      # Contas a pagar
      @bills_to_pay = BillsToPay.where(status: false)
      @bills_to_pay_total_value = @bills_to_pay.sum { |bill| bill.value.to_f }

      # Contas pagas
      @bills_paid = BillsToPay.where(status: true)
      @bills_paid_total_value = @bills_paid.sum { |bill| bill.value.to_f }

      # Valor recebido
      @received = Received.all
      @received_total_value = @received.sum { |received| received.lauch_value.to_f }

      # fluxo de caixa
      @cash_flow = CashFlow.where(lauch_type: "Entrada")
      @cash_flow_total_value = @cash_flow.sum { |cash| cash.lauch_value.to_f }

      # saldo
      @balance = @cash_flow_total_value - (@operational_costs_total_value + @additional_charges_total_value +
      @bills_paid_total_value)

      # à receber total
      # Calcula o total a receber garantindo que não seja negativo
      total_sum = @service_total_value + @additional_charges_total_value
      @total_to_receive = [total_sum - @received_total_value, 0].max

      # Dados de ExecutionService
      ExecutionService.where("service_date >= ?", 12.months.ago).group_by_month(
        :service_date,
        format: "%b %Y",
      ).sum(:total)

      monthly_statement
      years_records
      calc_month
      date_years_records
      months_records

      render("welcome/index")
    end

    private

    def who_is_logged
      @logger = true
    end

    def monthly_statement
      # Timezone
      tz = TZInfo::Timezone.get("America/Caracas") # ou "America/La_Paz"
      current_time = tz.to_local(Time.current)

      current_date = current_time.to_date

      # Retornar o mês atual
      @current_month = current_time.month

      # Retornar o ano atual
      @current_year = current_time.year

      @year = params[:year]&.to_i || @current_year

      @month = params[:month]&.to_i || @current_month

      @start_date = Date.new(@year, @month, 1)
      @end_date = @start_date.end_of_month

      start_time = @start_date.to_time

      # Retornar o mês atual e o ano atual formatados
      @current_date_format = I18n.l(start_time, format: :month_year, locale: :"pt-BR")

      # Valor Recebido agrupado por dia
      received = Received.where(lauch_date: @start_date..@end_date).group_by_day(
        :lauch_date,
        format: "%d-%m-%Y",
      ).sum(:lauch_value)

      # Filtrar valores maiores que 0
      received = received.select { |_, value| value.to_f != 0 }

      # outras entradas
      other_entries = CashFlow.where(
        lauch_date: @start_date..@end_date,
        lauch_type: "Entrada",
        source_model: "cash_flow",
      ).group_by_day(
        :lauch_date,
        format: "%d-%m-%Y",
      ).sum(:lauch_value)

      # Filtrar valores maiores que 0
      other_entries = other_entries.select { |_, value| value.to_f != 0 }

      # saidas de caixa
      cash_outflows = CashFlow.where(
        lauch_date: @start_date..@end_date,
        lauch_type: "Saída",
      ).group_by_day(
        :lauch_date,
        format: "%d-%m-%Y",
      ).sum(:lauch_value)

      # saídas de caixa
      cash_outflows = cash_outflows.select { |_, value| value.to_f != 0 }

      # entradas
      cash_entries = received.merge(other_entries) do |_, received_value, other_entries_value|
        received_value.to_f + other_entries_value.to_f
      end

      #Combinar os dados
      cash_flow_combination = [
        {
          name: "Entradas",
          data: cash_entries
            .sort_by { |date, _| Date.parse(date) },
        },
        {
          name: "Saídas de Caixa",
          data: cash_outflows
            .transform_values { |value| value.to_f * -1 }
            .sort_by { |date, _| Date.parse(date) },
        },
      ]

      if cash_outflows.length > 0 || cash_entries.length > 0
        @cash_flow = cash_flow_combination.sort_by do |group|
          if group[:data].present? && group[:data].first.present?
            Date.strptime(group[:data].first.first, "%d-%m-%Y")
          else
            Date.today
          end
        end
      end

      # total recebido
      @received_total = Received.where(lauch_date: @start_date..@end_date).sum(:lauch_value).to_f

      # contas à pagar agrupado por mês
      @bills_to_pays = BillsToPay.where(
        expiration_date: @start_date..@end_date,
        status: false,
      ).order(expiration_date: :asc)

      # contas à pagar agrupado por mês
      @bills = BillsToPay.joins(:categories_accounts_payable).where(
        expiration_date: @start_date..@end_date,
      ).group(
        "categories_accounts_payables.name",
      ).sum(:value)

      # Converter valores para números
      @bills = @bills.transform_values(&:to_f)

      # Calcular o total de todas as contas
      total_value = @bills.values.sum

      # Calcular o percentual de cada categoria
      @bills_percentages = @bills.transform_values do |value|
        (value / total_value * 100).round(2)
      end

      # Nova hash para armazenar os resultados
      @bills_with_due_info = []
      # Inicializa o total a pagar
      @total_payable = 0

      @bills_to_pays.each do |bill|
        expiration_date = bill.expiration_date
        days_until_due = (expiration_date - current_date).to_i

        due_info = if days_until_due > 0
          "Vence daqui a #{days_until_due} dias"
        else
          "Venceu há #{days_until_due.abs} dias"
        end

        # Adiciona a informação de vencimento ao hash de atributos do bill
        bill_with_due_info = bill.attributes
        bill_with_due_info["expiration"] = due_info

        @bills_with_due_info << bill_with_due_info

        # Soma o valor da conta ao total
        @total_payable += bill.value.to_f
      end
    end

    def calc_month
      # recebimnetos
      previous_month_received = Received.where(
        lauch_date: @start_date..@end_date,
      ).sum(:lauch_value)

      # pagamentos
      previous_month_bills_to_pays = BillsToPay.where(
        pay_day: @start_date..@end_date,
        status: true,
      ).sum(:value)

      # custos operacionais
      previous_month_operational_costs = OperationalCost.where(
        lauch_date: @start_date..@end_date,
      ).sum(:lauch_value)

      # custos adicionais
      previous_month_additional_charges = AdditionalCharge.where(
        lauch_date: @start_date..@end_date,
      ).sum(:lauch_value)

      # Total dos custos
      previous_month_total_costs = previous_month_bills_to_pays.to_f +
        previous_month_operational_costs.to_f +
        previous_month_additional_charges.to_f

      # lucro líquido
      previous_month_profit = previous_month_received.to_f - previous_month_total_costs.to_f

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
      fixed_costs = BillsToPay.where(
        pay_day: @start_date..@end_date,
        status: true,
        category_id: fixed_costs_category_ids,
      ).sum(:value)

      # custo variável
      variable_costs = BillsToPay.where(
        pay_day: @start_date..@end_date,
        status: true,
        category_id: variable_costs_category_ids,
      ).sum(:value)

      # Outras entradas
      other_entries = CashFlow.where(
        lauch_date: @start_date..@end_date,
        lauch_type: "Entrada",
        source_model: "cash_flow",
      ).sum(:lauch_value)

      # Estrutura de dados do faturamento
      @billing = {
        "Recebimentos": previous_month_received,
        "Custo Fixo": fixed_costs,
        "Custo Variavel": variable_costs,
        "Custo Operacional": previous_month_operational_costs,
        "Custo Adcional": previous_month_additional_charges,
        "Lucro": previous_month_profit,
        "Outras Entradas": other_entries,
        "Saldo": @balance_record,
      }

      # Filtrar valores diferentes de 0
      @billing_filtered = @billing.select { |_, value| value.to_f != 0 }
    end

    def years_records
      if Received.any? && CashFlow.any?
        # Definir a data final como a data do primeiro registro no banco de dados
        @start_date_received = Received.order(:lauch_date).first.lauch_date

        # Recebimentos
        received_record = Received.where(
          lauch_date: @start_date_received..@end_date,
        ).sum(:lauch_value)

        # Definir a data final como a data do primeiro registro no banco de dados
        @start_date_cash_flow = CashFlow.order(:lauch_date).first.lauch_date

        # custos pagos
        costs_paid = CashFlow.where(
          lauch_type: "Saída",
          lauch_date: @start_date_cash_flow..@end_date,
        ).sum(:lauch_value)

        # outras entradas
        other_entries = CashFlow.where(
          lauch_date: @start_date_cash_flow..@end_date,
          lauch_type: "Entrada",
          source_model: "cash_flow",
        ).sum(:lauch_value)

        # lucro líquido
        profit_record = received_record.to_f - costs_paid.to_f

        # Saldo
        @balance_record = profit_record.to_f + other_entries.to_f
      end
    end

    # Registro Anual
    def date_years_records
      @years_records = []

      # Consultar todos os anos distintos de Received, BillsToPay, OperationalCost, AdditionalCharge e CashFlow
      received_years = Received.where.not(
        lauch_date: nil,
      ).pluck(
        Arel.sql("DISTINCT EXTRACT(YEAR FROM lauch_date)"),
      ).map(&:to_i)
      bills_to_pay_years = BillsToPay.where.not(
        pay_day: nil,
      ).pluck(Arel.sql("DISTINCT EXTRACT(YEAR FROM pay_day)")).map(&:to_i)
      operational_cost_years = OperationalCost.where.not(
        lauch_date: nil,
      ).pluck(Arel.sql("DISTINCT EXTRACT(YEAR FROM lauch_date)")).map(&:to_i)
      additional_charge_years = AdditionalCharge.where.not(
        lauch_date: nil,
      ).pluck(Arel.sql("DISTINCT EXTRACT(YEAR FROM lauch_date)")).map(&:to_i)
      cash_flow_years = CashFlow.where.not(
        lauch_date: nil,
      ).pluck(Arel.sql("DISTINCT EXTRACT(YEAR FROM lauch_date)")).map(&:to_i)

      # Unir todos os anos distintos e remover duplicatas
      @years_records = (received_years + bills_to_pay_years +
      operational_cost_years + additional_charge_years + cash_flow_years).uniq

      # Ordenar os anos em ordem decrescente
      @years_records.sort! { |a, b| b <=> a }
    end

    # meses
    def months_records
      @months_records = [
        ["Janeiro", 1],
        ["Fevereiro", 2],
        ["Março", 3],
        ["Abril", 4],
        ["Maio", 5],
        ["Junho", 6],
        ["Julho", 7],
        ["Agosto", 8],
        ["Setembro", 9],
        ["Outubro", 10],
        ["Novembro", 11],
        ["Dezembro", 12],
      ]
    end
  end
end
