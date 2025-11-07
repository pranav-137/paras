# class BookingsController < ApplicationController
#   before_action :authenticate_user!

#   def new
#     @property = Property.find(params[:property_id])
#     @booking = @property.bookings.new
#   end

#   def create
#     @property = Property.find(params[:property_id])
#     @booking = @property.bookings.new(booking_params)
#     @booking.tenant = current_user  # tenant is current_user
#     @booking.status = "Pending"

#     if @booking.save
#       redirect_to bookings_path, notice: "Booking confirmed!"
#     else
#       render :new, status: :unprocessable_entity
#     end
#   end

# def index
#     if current_user.tenant?
#       # Tenant sees their own bookings
#       @bookings = current_user.bookings_as_tenant.includes(:property)
#     elsif current_user.owner?
#       # Owner sees all bookings for their properties
#       @bookings = current_user.bookings_as_owner.includes(:property)
#     else
#       # Admin or others (optional)
#       @bookings = Booking.includes(:property, :tenant).all
#     end
#   end

#   def show
#     @booking = Booking.find(params[:id])
#   end
#   def destroy
#     @booking.destroy
#     redirect_to bookings_path, notice: "Booking deleted successfully!"
#   end


#   private

#   def booking_params
#     params.require(:booking).permit(:start_date, :end_date, :message)
#   end
# end
# app/controllers/bookings_controller.rb
# class BookingsController < ApplicationController
#   before_action :authenticate_user!

#   def index
#     if current_user.tenant?
#       # Tenant sees their own bookings
#       @bookings = current_user.bookings_as_tenant.includes(:property)
#     elsif current_user.owner?
#       # Owner sees all bookings for their properties
#       @bookings = current_user.bookings_as_owner.includes(:property)
#     else
#       # Admin or others (optional)
#       @bookings = Booking.includes(:property, :tenant).all
#     end
#   end

#   def show
#     @booking = Booking.find(params[:id])
#   end
# end
class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:show, :destroy]

  def new
    @property = Property.find(params[:property_id])
    @booking = @property.bookings.new
  end

  def create
    @property = Property.find(params[:property_id])
    @booking = @property.bookings.new(booking_params)
    @booking.tenant = current_user  # tenant is current_user
    @booking.status = "Pending"

    if @booking.save
      redirect_to bookings_path, notice: "Booking confirmed!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    if current_user.tenant?
      # Tenant sees their own bookings
      @bookings = current_user.bookings_as_tenant.includes(:property)
    elsif current_user.owner?
      # Owner sees all bookings for their properties
      @bookings = current_user.bookings_as_owner.includes(:property)
    else
      # Admin or others (optional)
      @bookings = Booking.includes(:property, :tenant).all
    end
  end

  def show
  end

  def destroy
    if @booking
      @booking.destroy
      redirect_to bookings_path, notice: "Booking deleted successfully!"
    else
      redirect_to bookings_path, alert: "Booking not found or access denied!"
    end
  end

  private

  def set_booking
    @booking = Booking.find_by(id: params[:id])
    # Ensure booking is accessible to current user (tenant or owner)
    unless @booking && (
      (current_user.tenant? && @booking.tenant_id == current_user.id) ||
      (current_user.owner? && @booking.property.owner.user_id == current_user.id)
    )
      @booking = nil
    end
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :message)
  end
end