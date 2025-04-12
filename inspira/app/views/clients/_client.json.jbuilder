# frozen_string_literal: true

json.extract!(client, :id, :name_client, :legal_situation, :number_doc, :created_at, :updated_at)
json.url(client_url(client, format: :json))
