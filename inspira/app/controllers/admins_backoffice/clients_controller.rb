# frozen_string_literal: true

module AdminsBackoffice
  class ClientsController < ApplicationController
    before_action :authenticate_admin!
    before_action :who_is_logged
    layout "admins_backoffice"

    before_action :set_client, only: [:show, :edit, :update, :destroy, :show_client]

    # GET /clients or /clients.json
    def index
      # Query base
      base_query = Client.includes(:phones, :addresses, :emails)

      @clients = if params[:search].present?
        # Aplicar busca mantendo os includes
        base_query.search(params[:search])
          .where(deleted: false)
          .order(name_client: :asc)
          .page(params[:page])
          .per(10)
      else
        base_query.where(deleted: false)
          .order(name_client: :asc)
          .page(params[:page])
          .per(10)
      end

      render("clients/index")
    end

    # GET /clients/search
    def search
      @clients = Client.search(params[:search]).order(name_client: :asc).page(params[:page]).per(5)
      render(json: @clients)
    end

    # Get /clients/1
    def show_client
      render(json: @client)
    end

    # Get phones of client
    def phones
      @client = Client.find(params[:id]).phones
      render(json: @client)
    end

    # Get emails of client
    def emails
      @client = Client.find(params[:id]).emails
      render(json: @client)
    end

    # Get addresses of client
    def addresses
      @client = Client.find(params[:id]).addresses
      render(json: @client)
    end

    # GET /clients/1 or /clients/1.json
    def show
      render("clients/show")
    end

    # GET /clients/new
    def new
      @client = Client.new
      @client.phones.build
      @client.emails.build
      @client.addresses.build

      render("clients/new")
    end

    # GET /clients/1/edit
    def edit
      render("clients/edit")
    end

    # POST /clients or /clients.json
    def create
      @client = Client.new(client_params)
      @client.deleted = false

      respond_to do |format|
        if @client.save
          format.html do
            redirect_to(admins_backoffice_clients_path, notice: "Cliente foi criado com sucesso.")
          end
          format.json { render(:show, status: :created, location: @client) }
        else
          format.html { render("clients/new", status: :unprocessable_entity) }
          format.json { render(json: @client.errors, status: :unprocessable_entity) }
        end
      end
    end

    # PATCH/PUT /clients/1 or /clients/1.json
    def update
      # handle_logical_deletion_of_addresses
      respond_to do |format|
        if @client.update(client_params)
          format.html do
            redirect_to(admins_backoffice_clients_path, notice: "Cliente foi atualizado com sucesso.")
          end
          format.json { render(:show, status: :ok, location: @client) }
        else
          format.html { render("clients/edit", status: :unprocessable_entity) }
          format.json { render(json: @client.errors, status: :unprocessable_entity) }
        end
      end
    end

    # DELETE /clients/1 or /clients/1.json
    def destroy
      @client = Client.find(params[:id])
      @client.update(deleted: true)

      respond_to do |format|
        format.turbo_stream { render(turbo_stream: turbo_stream.remove("client_#{params[:id]}")) }
        format.html { redirect_to(admins_backoffice_clients_path, notice: "Cliente apagado com sucesso.") }
        format.json do
          render(
            json: { redirect_url: admins_backoffice_clients_path, notice: "Cliente apagado com sucesso." },
            status: :ok,
          )
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find_by(id: params[:id])
      unless @client
        redirect_to(admins_backoffice_clients_path, alert: "Cliente não encontrado.")
      end
    end

    def handle_logical_deletion_of_addresses
      # Verifica se params[:client] e params[:client][:addresses_attributes] existem antes de iterar
      if params[:client] && params[:client][:addresses_attributes].is_a?(Array)
        params[:client][:addresses_attributes].each do |attributes|
          next unless attributes["_destroy"] == "true" && attributes["id"].present?

          address = Address.find(attributes["id"])
          address.update(deleted: true)
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.require(:client).permit(
        :name_client,
        :legal_situation,
        :number_doc,
        :deleted,
        phones_attributes: [:id, :phone, :_destroy],
        emails_attributes: [:id, :email, :_destroy],
        addresses_attributes: [:id, :neighborhood, :street, :city, :cep, :add_number, :uf, :complement, :deleted],
      )
    end

    def who_is_logged
      @logger = true
    end
  end
end
