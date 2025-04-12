# frozen_string_literal: true

module AdminsBackoffice
  class CategoriesAccountsPayablesController < ApplicationController
    before_action :authenticate_admin!
    before_action :who_is_logged
    layout "admins_backoffice"

    before_action :set_categories_accounts_payable, only: [:show, :edit, :update, :destroy]
    before_action :set_type_of_account_options, only: [:new, :edit, :create]

    # GET /categories_accounts_payables or /categories_accounts_payables.json
    def index
      @categories_accounts_payables = CategoriesAccountsPayable.all
      render("categories_accounts_payables/index")
    end

    # GET /categories_accounts_payables/1 or /categories_accounts_payables/1.json
    def show
      render("categories_accounts_payables/show")
    end

    # GET /categories_accounts_payables/new
    def new
      @categories_accounts_payable = CategoriesAccountsPayable.new
      render("categories_accounts_payables/new")
    end

    # GET /categories_accounts_payables/1/edit
    def edit
      render("categories_accounts_payables/edit")
    end

    # POST /categories_accounts_payables or /categories_accounts_payables.json
    def create
      @categories_accounts_payable = CategoriesAccountsPayable.new(categories_accounts_payable_params)

      respond_to do |format|
        if @categories_accounts_payable.save
          format.html do
            redirect_to(
              admins_backoffice_categories_accounts_payables_path,
              notice: "As categorias contas a pagar foram criadas com sucesso.",
            )
          end
          format.json { render(:show, status: :created, location: @categories_accounts_payable) }
        else
          format.html { render("categories_accounts_payables/new", status: :unprocessable_entity) }
          format.json { render(json: @categories_accounts_payable.errors, status: :unprocessable_entity) }
        end
      end
    end

    # PATCH/PUT /categories_accounts_payables/1 or /categories_accounts_payables/1.json
    def update
      respond_to do |format|
        if @categories_accounts_payable.update(categories_accounts_payable_params)
          format.html do
            redirect_to(
              admins_backoffice_categories_accounts_payables_path,
              notice: "As categorias contas a pagar foram atualizadas com sucesso.",
            )
          end
          format.json { render(:show, status: :ok, location: @categories_accounts_payable) }
        else
          format.html { render("categories_accounts_payables/edit", status: :unprocessable_entity) }
          format.json { render(json: @categories_accounts_payable.errors, status: :unprocessable_entity) }
        end
      end
    end

    # DELETE /categories_accounts_payables/1 or /categories_accounts_payables/1.json
    def destroy
      if @categories_accounts_payable.bills_to_pays.count == 0
        @categories_accounts_payable.destroy!

        respond_to do |format|
          format.turbo_stream { render(turbo_stream: turbo_stream.remove("categories_accounts_payable_#{params[:id]}")) }
          format.html do
            redirect_to(
              admins_backoffice_categories_accounts_payables_path,
              notice: "As categorias contas a pagar foram exluidas com sucesso.",
            )
          end
          format.json { head(:no_content) }
        end
      end
    end

    private

    def set_type_of_account_options
      @type_of_account_options = TypeOfAccount.all.map { |t| [t.name_account, t.id] }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_categories_accounts_payable
      @categories_accounts_payable = CategoriesAccountsPayable.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def categories_accounts_payable_params
      params.require(:categories_accounts_payable).permit(:type_account_id, :name)
    end

    def who_is_logged
      @logger = true
    end
  end
end
