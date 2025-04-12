# frozen_string_literal: true

module AdminsBackoffice
  class ListServicesController < ApplicationController
    before_action :authenticate_admin!
    before_action :who_is_logged
    layout "admins_backoffice"
    before_action :set_list_service, only: [:show, :edit, :update, :destroy]

    # GET /list_services or /list_services.json
    def index
      @list_services = ListService.where(list_delete: false).order(service_name: :asc).page(params[:page])
      render("list_services/index")
    end

    # GET /list_services/1 or /list_services/1.json
    def show
      render("list_services/show")
    end

    # GET /list_services/new
    def new
      @list_service = ListService.new
      render("list_services/new")
    end

    # GET /list_services/1/edit
    def edit
      render("list_services/edit")
    end

    # POST /list_services or /list_services.json
    def create
      @list_service = ListService.new(list_service_params)
      @list_service.list_delete = false

      respond_to do |format|
        if @list_service.save
          format.html do
            redirect_to(admins_backoffice_list_services_path, notice: "Serviço criado com sucesso.")
          end
          format.json { render(:show, status: :created, location: @list_service) }
        else
          format.html { render("list_services/new", status: :unprocessable_entity) }
          format.json { render(json: @list_service.errors, status: :unprocessable_entity) }
        end
      end
    end

    # PATCH/PUT /list_services/1 or /list_services/1.json
    def update
      respond_to do |format|
        # Marca o serviço atual como deletado
        if @list_service.update(list_delete: true)
          # Prepara os parâmetros do novo serviço, garantindo que list_delete seja false
          new_service_params = list_service_params.merge(list_delete: false)

          # Cria um novo serviço com os parâmetros ajustados
          new_service = ListService.new(new_service_params)

          if new_service.save
            format.html { redirect_to(admins_backoffice_list_services_path, notice: "Serviço atualizado com sucesso.") }
            format.json { render(:show, status: :ok, location: new_service) }
          else
            # Se não conseguir salvar o novo serviço, renderiza a página de edição com os erros
            format.html { render(:edit, status: :unprocessable_entity) }
            format.json { render(json: new_service.errors, status: :unprocessable_entity) }
          end
        else
          # Se não conseguir atualizar o serviço como deletado, renderiza a página de edição com os erros
          format.html { render(:edit, status: :unprocessable_entity) }
          format.json { render(json: @list_service.errors, status: :unprocessable_entity) }
        end
      end
    end

    # DELETE /list_services/1 or /list_services/1.json
    def destroy
      if @list_service.execution_services.count == 0
        @list_service.destroy!

        respond_to do |format|
          format.turbo_stream { render(turbo_stream: turbo_stream.remove("list_service_#{params[:id]}")) }
          format.html do
            redirect_to(
              admins_backoffice_list_services_path,
              notice: "As categorias contas a pagar foram exluidas com sucesso.",
            )
          end
          format.json { head(:no_content) }
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_list_service
      @list_service = ListService.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def list_service_params
      params.require(:list_service).permit(:service_name, :list_delete)
    end

    def who_is_logged
      @logger = true
    end
  end
end
