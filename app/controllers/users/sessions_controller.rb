# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  def after_sign_in_path_for(resource)
    case resource.role
    when 'admin'  then admin_path # Fixed!
    when 'owner'  then owners_path
    when 'tenant' then tenants_path
    else root_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end