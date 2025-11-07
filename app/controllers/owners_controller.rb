class OwnersController < ApplicationController
  before_action :authenticate_user!
 before_action :allow_owner_or_admin


def index
  @owner = Owner.find_or_initialize_by(user_id: current_user.id) do |owner|
    owner.email = current_user.email
  end

  @ownerdoc = current_user.ownerdocs.first
  @properties = current_user.properties
end

  # New or edit owner details
  def new
    if current_user.owner.present?
      redirect_to edit_owner_path(current_user.owner), alert: "You have already added your details. You can edit them here."
    else
      @owner = Owner.new
    end
  end

  def create
    @owner = current_user.build_owner(owner_params)
    if @owner.save
      redirect_to owners_path, notice: "Details added successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  

  def edit
    @owner = current_user.owner
  end

  def update
    @owner = current_user.owner
    if @owner.update(owner_params)
      redirect_to owners_path, notice: "Profile updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def owner_params
    params.require(:owner).permit(:first_name, :last_name, :email, :address_line, :city, :state, :country, :pin_code)
  end
end
