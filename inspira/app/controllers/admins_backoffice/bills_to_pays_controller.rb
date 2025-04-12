# frozen_string_literal: true

module AdminsBackoffice
  class BillsToPaysController < ApplicationController
    before_action :authenticate_admin!
    before_action :who_is_logged
    layout "admins_backoffice"

    before_action :set_bills_to_pay, only: [:show, :edit, :update, :save_payment, :add_payment, :destroy]
    before_action :set_categories_accounts_payables, only: [:new, :edit, :create, :update]

    # GET /bills_to_pays or /bills_to_pays.json
    def index
      @bills_to_pays = BillsToPay.includes(:categories_accounts_payable)
        .order(expiration_date: :desc)
        .page(params[:page])
        .per(10)
      render("bills_to_pays/index")
    end

    def filter
      bills_to_pays = BillsToPay.includes(:categories_accounts_payable).all

      bills_to_pays = case params[:filter]
      when "not_paid" then BillsToPay.not_paid
      when "current_month" then BillsToPay.current_month
      when "previous_month" then BillsToPay.previous_month
      when "next_month" then BillsToPay.next_month
      else bills_to_pays
      end

      if params[:range_date_payment].present?
        start_date, end_date = parse_dates(params[:range_date_payment])
        bills_to_pays = bills_to_pays.by_pay_day(start_date, end_date)
      end

      if params[:range_date_expiration].present?
        start_date, end_date = parse_dates(params[:range_date_expiration])
        bills_to_pays = bills_to_pays.by_expiration_date(start_date, end_date)
      end

      bills_to_pays = bills_to_pays.filter_by_account(params[:account_type_name]) if params[:account_type_name].present?
      bills_to_pays = bills_to_pays.by_category(params[:category]) if params[:category].present?
      bills_to_pays = bills_to_pays.by_status(params[:situation]) if params[:situation].present?

      @bills_to_pays = bills_to_pays.order(expiration_date: :desc).page(params[:page]).per(10)

      respond_to do |format|
        format.html { render("bills_to_pays/index") }
        # format.turbo_stream { render("bills_to_pays/filter_message") }
      end
    end

    # GET /bills_to_pays/1 or /bills_to_pays/1.json
    def show
      render("bills_to_pays/show")
    end

    def add_payment
      respond_to do |format|
        format.turbo_stream do
          render("bills_to_pays/add_payment")
        end
      end
    end

    def save_payment
      respond_to do |format|
        if @bills_to_pay.update(bills_to_pay_params)
          flash.now[:notice] = "Pagamento efetuado com sucesso."
          format.turbo_stream { render("bills_to_pays/save_payment") }
        else
          flash.now[:alert] = @bills_to_pay.errors.full_messages.join(", ")
          format.turbo_stream { render("bills_to_pays/add_payment") }
        end
      end
    end

    # GET /bills_to_pays/new
    def new
      @bills_to_pay = BillsToPay.new
      render("bills_to_pays/new")
    end

    # GET /bills_to_pays/1/edit
    def edit
      render("bills_to_pays/edit")
    end

    # POST /bills_to_pays or /bills_to_pays.json
    def create
      if bills_to_pay_params.is_a?(Array)
        errors = []

        bills_to_pay_params.each do |bill_params|
          @bills_to_pay = BillsToPay.new(bill_params)
          @bills_to_pay.deleted = false
          unless @bills_to_pay.save
            errors << @bills_to_pay.errors.full_messages
          end
        end

        respond_to do |format|
          if errors.empty?

            format.html { redirect_to(admins_backoffice_bills_to_pays_path, notice: "Lançamentos salvos com sucesso.") }
            format.json do
              render(
                json: {
                  redirect_url: admins_backoffice_bills_to_pays_path,
                  notice: "Lançamentos salvos com sucesso.",
                },
                status: :created,
              )
            end

          else
            format.html { render("bills_to_pays/new", status: :unprocessable_entity) }
            format.json { render(json: { errors: errors }, status: :unprocessable_entity) }
          end
        end
      else
        @bills_to_pay = BillsToPay.new(bills_to_pay_params)
        @bills_to_pay.deleted = false

        respond_to do |format|
          if @bills_to_pay.save

            format.html { redirect_to(admins_backoffice_bills_to_pays_path, notice: "Lançamento salvo com sucesso.") }
            format.json do
              render(
                json: {
                  redirect_url: admins_backoffice_bills_to_pays_path,
                  notice: "Lançamentos salvos com sucesso.",
                },
                status: :created,
              )
            end

          else
            format.html { render("bills_to_pays/new", status: :unprocessable_entity) }
            format.json { render(json: @bills_to_pay.errors, status: :unprocessable_entity) }
          end
        end
      end
    end

    # PATCH/PUT /bills_to_pays/1 or /bills_to_pays/1.json
    def update
      respond_to do |format|
        if @bills_to_pay.update(bills_to_pay_params)
          format.html do
            redirect_to(admins_backoffice_bills_to_pays_path, notice: "Conta atualizada com sucesso!!!.")
          end
          format.json { render(:show, status: :ok, location: @bills_to_pay) }
        else
          format.html { render("bills_to_pays/edit", status: :unprocessable_entity) }
          format.json { render(json: @bills_to_pay.errors, status: :unprocessable_entity) }
        end
      end
    end

    # DELETE /bills_to_pays/1 or /bills_to_pays/1.json
    def destroy
      @bills_to_pay.destroy!

      respond_to do |format|
        format.turbo_stream { render("bills_to_pays/remove_payment") }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_bills_to_pay
      @bills_to_pay = BillsToPay.find(params[:id])
    end

    def set_categories_accounts_payables
      @categories_accounts_payables = CategoriesAccountsPayable
        .includes(:type_of_account)
        .order(Arel.sql("type_of_accounts.name_account = 'Custo Fixo' DESC, type_of_accounts.name_account ASC"))
    end

    # Only allow a list of trusted parameters through.
    def bills_to_pay_params
      if params[:bills_to_pay].is_a?(Array)
        params.require(:bills_to_pay).map do |bill|
          bill.permit(:description, :expiration_date, :value, :status, :pay_day, :category_id, :deleted)
        end
      else
        params.require(:bills_to_pay).permit(
          :description,
          :expiration_date,
          :value,
          :status,
          :pay_day,
          :category_id,
          :deleted,
        )
      end
    end

    def who_is_logged
      @logger = true
    end

    def parse_dates(date_range)
      start_date, end_date = date_range.split(" até ").map do |date|
        Date.strptime(date, "%d/%m/%Y")
      rescue
        nil
      end
      [start_date, end_date]
    end
  end
end
