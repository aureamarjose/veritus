# frozen_string_literal: true

module AdminsBackoffice
  class CashFlowsController < ApplicationController
    before_action :authenticate_admin!
    before_action :who_is_logged
    before_action :date_ranges, only: [:index, :received]
    layout "admins_backoffice"

    def index
      @cash_flows = filtered_cash_flows
        .select("cash_flows.*, SUM(CASE WHEN lauch_type = 'Entrada' THEN lauch_value ELSE -lauch_value END) OVER (
        ORDER BY lauch_date ASC, id ASC) AS balance")
        .order(lauch_date: :desc, id: :desc)
        .page(params[:page] || 1)
        .per(10)
      render("cash_flows/index")
    end

    def received
      @cash_flows = filtered_entries
        .select("cash_flows.*, SUM(CASE WHEN cash_flows.lauch_type = 'Entrada' THEN cash_flows.lauch_value ELSE -cash_flows.
        lauch_value END) OVER (ORDER BY cash_flows.lauch_date ASC, cash_flows.id ASC) AS balance")
        .order(lauch_date: :asc, id: :asc)
        .page(params[:page] || 1)
        .per(10)
      render("cash_flows/index")
    end

    def search
      subquery = Received.joins(:service)
        .joins("INNER JOIN clients ON services.client_id = clients.id")
        .select("MIN(receiveds.id) as id")
        .group("clients.id")

      results = Received.joins(:service)
        .joins("INNER JOIN clients ON services.client_id = clients.id")
        .where("receiveds.id IN (#{subquery.to_sql})")
        .select("receiveds.*, clients.name_client as name_client")

      if params[:search].present?
        results = results.where("clients.name_client LIKE ?", "%#{params[:search]}%")
      end

      @results = results.order(name_client: :asc).page(params[:page]).per(5)

      render(json: @results)
    end

    def new
      @cash_flow = CashFlow.new
      render("cash_flows/new")
    end

    def create
      lauch_value = convert_to_number(params[:cash_flow][:lauch_value])
      @cash_flow = CashFlow.new(cash_flow_params.merge(lauch_value: lauch_value))

      @cash_flow.lauch_type = "Entrada"
      @cash_flow.source_model = "cash_flow"
      respond_to do |format|
        if @cash_flow.save
          format.html do
            redirect_to(admins_backoffice_cash_flows_path, notice: "Saldo adcionado ao caixa com sucesso.")
          end
        else
          format.html { render("cash_flows/new", status: :unprocessable_entity) }
        end
      end
    end

    def destroy
      @cash_flow = CashFlow.find(params[:id])
      @cash_flow.destroy!

      respond_to do |format|
        format.turbo_stream { render("cash_flows/remove") }
      end
    end

    private

    def filtered_cash_flows
      scope = CashFlow.order(lauch_date: :desc, id: :desc)
      scope = apply_date_filter(scope)
      scope = apply_type_filter(scope)
      scope
    end

    def apply_date_filter(scope)
      dates = date_ranges
      case params[:filter]
      when "today"
        scope.where(lauch_date: dates[:today])
      when "yesterday"
        scope.where(lauch_date: dates[:yesterday])
      when "current_month"
        scope.where(lauch_date: dates[:first_day_of_month]..dates[:end_day_of_month])
      when "current_year"
        scope.where(lauch_date: dates[:first_day_of_year]..dates[:end_day_of_year])
      when "last_month"
        scope.where(lauch_date: dates[:first_day_of_last_month]..dates[:end_day_of_last_month])
      when "last_year"
        scope.where(lauch_date: dates[:first_day_of_last_year]..dates[:end_day_of_last_year])
      when "last_six_months"
        scope.where(lauch_date: dates[:last_six_months]..dates[:end_day_of_month])
      else
        apply_custom_date_filter(scope)
      end
    end

    def apply_custom_date_filter(scope)
      return scope if params[:date].blank?

      start_date, end_date = params[:date].split(" até ").map { |date| Date.strptime(date, "%d/%m/%Y") }
      scope.where(lauch_date: start_date..end_date)
    end

    def apply_type_filter(scope)
      case params[:filter]
      when "Entrada"
        scope.where(lauch_type: "Entrada")
      when "Saída"
        scope.where(lauch_type: "Saída")
      when "add_money"
        scope.where(source_model: "cash_flow")
      else
        scope
      end
    end

    # received
    def filtered_entries
      scope = CashFlow.income_entries.ordered
      scope = apply_date_filter(scope)
      scope = scope.by_client(params[:search]) if params[:search].present?
      scope.includes(receiveds: { service: :client }) # Eager load
    end

    def add_balance_to_cash_flows(cash_flows)
      return [] if cash_flows.empty?

      @page = params[:page] || 1
      @per_page = 10

      # Processa apenas os registros filtrados
      processed_flows = cash_flows.each_with_object([]) do |flow, acc|
        # Calcula saldo inicial para o primeiro registro
        balance = if acc.empty?
          0
        else
          acc.last.balance.to_f
        end

        # Atualiza saldo baseado no tipo de lançamento
        balance += case flow.lauch_type
        when "Entrada" then flow.lauch_value.to_f
        else -flow.lauch_value.to_f
        end

        # Atribui saldo ao registro atual
        flow.balance = balance
        acc << flow
      end

      # Ordena por data e ID decrescente
      sorted_flows = processed_flows.sort_by do |flow|
        [-flow.lauch_date.to_time.to_i, -flow.id]
      end

      # Retorna resultados paginados
      Kaminari.paginate_array(sorted_flows).page(@page).per(@per_page)
    end

    # Only allow a list of trusted parameters through.
    def cash_flow_params
      params.require(:cash_flow).permit(:lauch_date, :lauch_description, :lauch_type, :lauch_value, :_destroy)
    end

    def convert_to_number(value)
      return value if value.is_a?(Numeric)

      value.gsub(/[^\d,]/, "").gsub(",", ".").to_f
    end

    def who_is_logged
      @logger = true
    end
  end
end
