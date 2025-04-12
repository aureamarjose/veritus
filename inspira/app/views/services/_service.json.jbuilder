# frozen_string_literal: true

json.extract!(
  service,
  :id,
  :folder,
  :sector,
  :start_date,
  :end_date,
  :financial_situation,
  :progress,
  :description,
  :clients_id,
  :created_at,
  :updated_at,
)
json.url(service_url(service, format: :json))
