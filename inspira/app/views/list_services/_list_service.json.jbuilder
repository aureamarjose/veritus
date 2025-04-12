# frozen_string_literal: true

json.extract!(list_service, :id, :service_name, :list_delete, :created_at, :updated_at)
json.url(list_service_url(list_service, format: :json))
