class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
    private

  # ✅ Allow only tenants or admins
  def allow_tenant_or_admin
    unless current_user&.tenant? || current_user&.admin?
      redirect_to root_path, alert: "Access denied"
    end
  end

  # ✅ Allow only owners or admins
  def allow_owner_or_admin
    unless current_user&.owner? || current_user&.admin?
      redirect_to root_path, alert: "Access denied"
    end
  end

  protected

  def configure_permitted_parameters
    # For sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
    # For account update (edit profile)
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role])
  end
end
