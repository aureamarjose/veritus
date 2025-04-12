# frozen_string_literal: true

module AdminsBackoffice
  class ProfilesController < AdminsBackofficeController
    before_action :authenticate_admin!
    before_action :who_is_logged
    # before_action :months_records, only: [:index]
    layout "admins_backoffice"

    def index
      render("profiles/index")
    end

    def edit_password
      render("profiles/edit_password")
    end

    def edit_profile
      render("profiles/edit_profile")
    end

    def update_password
      respond_to do |format|
        @admin.updating_password = true
        if @admin.update_with_password(password_params)
          bypass_sign_in(@admin)
          format.html { redirect_to(admins_backoffice_profiles_path, notice: "Senha atualizada com sucesso.") }
        else
          format.html { render("profiles/edit_password", status: :unprocessable_entity) }
        end
      end
    end

    def update_profile
      respond_to do |format|

        if @admin.update(admin_params)
          format.html { redirect_to(admins_backoffice_profiles_path, notice: "Administrador atualizado com sucesso.") }
        else
          format.html { render("profiles/edit_profile", status: :unprocessable_entity) }
        end
      end
    end

    private

    def who_is_logged
      @admin = current_admin
    end

    def password_params
      params.require(:admin).permit(:current_password, :password, :password_confirmation)
    end

    def admin_params
      params.require(:admin).permit(:name)
    end
  end
end
