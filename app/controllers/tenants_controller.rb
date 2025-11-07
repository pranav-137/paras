class TenantsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_tenant, only: [:show, :edit, :update, :destroy]
  before_action :allow_tenant_or_admin

  def index
    # Show all tenants (later you might restrict it)
    @tenants = Tenant.all
    @properties = Property.all # show property gallery for booking
  end

  def show
  end

  def new
    @tenant = Tenant.new
  end

  def create
    @tenant = Tenant.new(tenant_params)
    if @tenant.save
      redirect_to @tenant, notice: "Tenant profile created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @tenant.update(tenant_params)
      redirect_to @tenant, notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tenant.destroy
    redirect_to tenants_path, notice: "Tenant deleted successfully!"
  end

  private

  def set_tenant
    @tenant = Tenant.find(params[:id])
  end

  def tenant_params
    params.require(:tenant).permit(
      :first_name, :last_name, :street_address, :street_address_2,
      :city, :region, :postal_code, :country, :email, :phone,
      :check_in, :check_out, :adults, :children
    )
  end
end
