class PropertiesController < ApplicationController
  before_action :authenticate_user!,except: [:details]
  before_action :ensure_owner,except: [:details] 
  before_action :set_property, only: [:show, :edit, :update, :destroy]

  def index
    
    @properties = current_user.owner.properties
  end
  def details
   @property = Property.find(params[:id])
  end
  def new
    @property = current_user.owner.properties.new
  end

  def create
    @property = current_user.owner.properties.new(property_params)
    if @property.save
      redirect_to property_path(@property), notice: "Property added successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @property.update(property_params)
      redirect_to property_path(@property), notice: "Property updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @property.destroy
    redirect_to properties_path, notice: "Property was successfully deleted."
  end

  private

  def set_property
    @property = current_user.owner.properties.find_by(id: params[:id])
    unless @property
      redirect_to properties_path, alert: "Property not found or access denied"
    end
  end

  def property_params
    params.require(:property).permit(:name, images: [])
  end

  def ensure_owner
    redirect_to root_path, alert: "Access denied" unless current_user.owner?
  end
end
             