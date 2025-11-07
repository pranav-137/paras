class OwnerdocsController < ApplicationController
  before_action :authenticate_user!
  before_action :allow_owner_or_admin
  before_action :set_ownerdoc, only: [:edit, :update, :show, :destroy]

  def index
    @ownerdocs = current_user.ownerdocs
  end

def new
  if current_user.owner.ownerdocs.exists?
    redirect_to edit_ownerdoc_path(current_user.owner.ownerdocs.first),
                alert: "You have already uploaded your documents. You can edit them here."
  else
    @ownerdoc = current_user.owner.ownerdocs.new
  end
end


  def create
  if current_user.owner.nil?
    redirect_to root_path, alert: "Please complete your owner profile before uploading documents."
    return
  end

  @ownerdoc = current_user.owner.ownerdocs.new(ownerdoc_params)

  if @ownerdoc.save
    redirect_to ownerdocs_path, notice: "Documents uploaded successfully!"
  else
    render :new, status: :unprocessable_entity
  end
end


  def edit; end

  def update
    if @ownerdoc.update(ownerdoc_params)
      redirect_to ownerdocs_path, notice: "Documents updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  def destroy
    @ownerdoc.destroy
    redirect_to ownerdocs_path, notice: "Document deleted successfully!"
  end

  private

  def set_ownerdoc
    @ownerdoc = current_user.ownerdocs.find(params[:id])
  end

  def ownerdoc_params
    params.require(:ownerdoc).permit(:name, :doc_type, :profile_pic, :document)
  end

  def ensure_owner
    redirect_to root_path, alert: "Access denied" unless current_user.owner?
  end
end
