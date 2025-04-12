# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # configure_permitted_parameters is a method that allows us to add additional parameters to the devise sign up and account update forms. # rubocop:disable Layout/LineLength
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  # after_sign_in_path_for is a method that allows us to redirect the user to a specific page after they sign in.
  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      admins_backoffice_welcome_index_path
    else
      users_backoffice_welcome_index_path
    end
  end

  private

  # layout_by_resource verifica se o controller atual é um controller do Devise. Se for, ele retorna o layout específico para o recurso atual. Caso contrário, ele retorna o layout padrão da aplicação. # rubocop:disable Layout/LineLength
  def layout_by_resource
    devise_controller? ? "#{resource_class.to_s.downcase}_devise" : "application"
  end

  def date_ranges
    tz = TZInfo::Timezone.get("America/Caracas")
    current_time = tz.to_local(Time.current)
    today = tz.to_local(Time.now.utc).to_date

    {
      today: today,
      yesterday: today - 1.day,
      current_time: current_time,
      first_day_of_month: current_time.beginning_of_month.to_date,
      end_day_of_month: current_time.end_of_month.to_date,
      first_day_of_year: current_time.beginning_of_year.to_date,
      end_day_of_year: current_time.end_of_year.to_date,
      first_day_of_last_month: (current_time - 1.month).beginning_of_month.to_date,
      end_day_of_last_month: (current_time - 1.month).end_of_month.to_date,
      first_day_of_last_year: (current_time - 1.year).beginning_of_year.to_date,
      end_day_of_last_year: (current_time - 1.year).end_of_year.to_date,
      last_six_months: (current_time - 6.months).to_date,

    }
  end

end
