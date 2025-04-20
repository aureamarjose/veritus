# frozen_string_literal: true

module AdminsBackoffice
  class ServicesController < ApplicationController
    before_action :authenticate_admin!
    before_action :who_is_logged
    layout "admins_backoffice"
    helper_method :service_names_map # Torna o método acessível na view
    before_action :set_service, only: [:show, :edit, :update, :destroy]

    # GET /services or /services.json
    def index
      @services = Service.includes(
        :client,
        :additional_charges,
        :execution_services,
        :operational_costs,
        :receiveds,
        :address,
      )
        .joins("INNER JOIN clients as client1 ON services.client_id = client1.id")
        .joins("LEFT JOIN clients as client2 ON services.exc_client2_id = client2.id")
        .by_folder(params[:folder])
        .by_name_contractor(params[:name_contractor])
        .by_client_name(params[:client_name])
        .by_street(params[:street])
        .by_financial_situation(params[:financial_situation])
        .by_progress(params[:progress])
        .ordered_by_folder
        .page(params[:page]).per(10)

      render("services/index")
    end

    # GET /services/1 or /services/1.json
    def show
      @client = @service.client
      render("services/show")
    end

    # GET /services/1/client or /services/1/client.json
    def show_service
      @service = Service.find(params[:id])
      @client = @service.client
      render(json: @client)
    end

    # GET /services/new
    def new
      @service = Service.new
      @service.execution_services.build
      @service.additional_charges.build
      @service.operational_costs.build
      @service.receiveds.build
      @execution_services = []
      last_folder = Service.any? ? Service.last.folder : nil
      @next_number_folder = last_folder.present? ? last_folder.to_i + 1 : 1
      render("services/new")
    end

    # GET /services/1/edit
    def edit
      @service = Service.find(params[:id])
      @client = @service.client
      @exc_client = @service.exc_client2
      @address = @service.address
      # Carregar os dados da tabela execution_service associados ao service
      @execution_services = @service.execution_services.includes(:list_service)
      render("services/edit")
    end

    # POST /services or /services.json
    def create
      @service = Service.new(service_params)
      @execution_services = @service.execution_services.includes(:list_service)

      respond_to do |format|
        if @service.save
          format.html do
            redirect_to(admins_backoffice_services_path, notice: I18n.t('activerecord.message.success',  model: Service.model_name.human))
          end
          format.json { render(:show, status: :created, location: @service) }
        else
          format.html { render("services/new", status: :unprocessable_entity) }
          format.json { render(json: @service.errors, status: :unprocessable_entity) }
        end
      end
    end

    # PATCH/PUT /services/1 or /services/1.json
    def update
      @execution_services = @service.execution_services.includes(:list_service)

      respond_to do |format|
        if @service.update(service_params)
          format.html { redirect_to(admins_backoffice_services_path, notice: I18n.t('activerecord.message.update',  model: Service.model_name.human)) }
          format.json { render(:show, status: :ok, location: @service) }
        else
          format.html { render("services/edit", status: :unprocessable_entity) }
          format.json { render(json: @service.errors, status: :unprocessable_entity) }
        end
      end
    end

    # DELETE /services/1 or /services/1.json
    def destroy
      @service.destroy!

      respond_to do |format|
        format.turbo_stream { render(turbo_stream: turbo_stream.remove("service_#{params[:id]}")) }
        format.html { redirect_to(admins_backoffice_services_path, notice: "O serviço foi destruído com sucesso.") }
        format.json { head(:no_content) }
      end
    end

    private

    def service_names_map
      ListService.all.pluck(:id, :service_name).to_h
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def service_params
      params.require(:service).permit(
        :folder,
        :sector,
        :start_date,
        :end_date,
        :financial_situation,
        :progress,
        :description,
        :client_id,
        :exc_client2_id,
        :address_id,
        execution_services_attributes: [:id, :service_date, :list_service_id, :amount, :value, :total, :_destroy],
        additional_charges_attributes: [:id, :lauch_date, :release_description, :lauch_value, :_destroy],
        operational_costs_attributes: [
          :id,
          :lauch_date,
          :release_description,
          :lauch_value,
          :list_service_id,
          :_destroy,
        ],
        receiveds_attributes: [:id, :lauch_date, :release_description, :lauch_value, :_destroy],
      )
    end

    def who_is_logged
      @logger = true
    end
  end
end
