# frozen_string_literal: true

module UsersBackoffice
  class ClientsController < ApplicationController
    before_action :authenticate_user!
    before_action :who_is_logged
    layout "users_backoffice"

    before_action :set_client, only: [:show, :edit, :update, :destroy]

    # GET /clients or /clients.json
    def index
      @clients = Client.all
      render("clients/index")
    end

    # GET /clients/1 or /clients/1.json
    def show
      render("clients/show")
    end

    # GET /clients/new
    def new
      @client = Client.new
      render("clients/new")
    end

    # GET /clients/1/edit
    def edit
      render("clients/edit")
    end

    # POST /clients or /clients.json
    def create
      @client = Client.new(client_params)
      Rails.logger.debug("Client: #{client_params}")
      respond_to do |format|
        if @client.save
          format.html { redirect_to(users_backoffice_client_path(@client), notice: "Client was successfully created.") }
          format.json { render(:show, status: :created, location: @client) }
        else
          format.html { render(:new, status: :unprocessable_entity) }
          format.json { render(json: @client.errors, status: :unprocessable_entity) }
        end
      end
    end

    # PATCH/PUT /clients/1 or /clients/1.json
    def update
      respond_to do |format|
        if @client.update(client_params)
          format.html { redirect_to(users_backoffice_client_path(@client), notice: "Client was successfully updated.") }
          format.json { render(:show, status: :ok, location: @client) }
        else
          format.html { render(:edit, status: :unprocessable_entity) }
          format.json { render(json: @client.errors, status: :unprocessable_entity) }
        end
      end
    end

    # DELETE /clients/1 or /clients/1.json
    def destroy
      @client.destroy!

      respond_to do |format|
        format.html { redirect_to(users_backoffice_client_path, notice: "Client was successfully destroyed.") }
        format.json { head(:no_content) }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find_by(id: params[:id])
      unless @client
        redirect_to(users_backoffice_clients_path, alert: "Cliente não encontrado.")
      end
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.require(:client).permit(
        :name_client,
        :legal_situation,
        :number_doc,
        phones_attributes: [:id, :phone, :_destroy],
      )
    end

    def who_is_logged
      @logger = false
    end
  end
end
