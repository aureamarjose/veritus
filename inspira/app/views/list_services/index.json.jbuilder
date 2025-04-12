# frozen_string_literal: true

json.array!(@list_services, partial: "list_services/list_service", as: :list_service)
