# class TenantdocsController < ApplicationController
#   before_action :authenticate_user!
#   before_action :set_tenantdoc, only: [:show, :edit, :update, :destroy]

#   def index
#     @tenantdocs = Tenantdoc.all
#   end

#   def new
#     @tenantdoc = Tenantdoc.new
#   end

#   def create
#     @tenantdoc = Tenantdoc.new(tenantdoc_params)
#     if @tenantdoc.save
#       redirect_to @tenantdoc, notice: "Successfully Created"
#     else
#       render :new, status: :unprocessable_entity
#     end
#   end

#   def edit
#   end

#   def update
#     if @tenantdoc.update(tenantdoc_params)
#       redirect_to @tenantdoc, notice: "Successfully Updated"
#     else
#       render :edit, status: :unprocessable_entity
#     end
#   end

#   def show
#   end

#   def destroy
#     @tenantdoc.destroy
#     redirect_to tenantdocs_path, notice: "Successfully Deleted"
#   end

#   private

#   def set_tenantdoc
#     @tenantdoc = Tenantdoc.find(params[:id])
#   end

#   def tenantdoc_params
#     params.require(:tenantdoc).permit(:name, :doc_type, :tenant_id, :profile_pic, :document)
#   end
# end
class TenantdocsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_tenantdoc, only: [:edit, :update, :show, :destroy]

  def index
    @tenantdocs = Tenantdoc.all
  end

  def new
    @tenantdoc = Tenantdoc.new
  end

  def create
    @tenantdoc = Tenantdoc.new(tenantdoc_params)
    if @tenantdoc.save
      redirect_to @tenantdoc, notice: "Tenant document uploaded successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @tenantdoc.update(tenantdoc_params)
      redirect_to @tenantdoc, notice: "Tenant document updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  def destroy
    @tenantdoc.destroy
    redirect_to tenantdocs_path, notice: "Document deleted successfully!"
  end

  private

  def set_tenantdoc
    @tenantdoc = Tenantdoc.find(params[:id])
  end

  def tenantdoc_params
    params.require(:tenantdoc).permit(:name, :doc_type, :tenant_id, :profile_pic, :document)
  end
end
