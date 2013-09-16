class ParkingRegistrationsController < ApplicationController
  def new
    @parking_registration = ParkingRegistration.new
  end

  def create
    @parking_registration = ParkingRegistration.new( parking_registration_params )

    if @parking_registration.park
      flash[:notice] = 'You registered successfully'
      redirect_to root_path
    else
      render :new
    end
  end

  private
  def parking_registration_params
    params.require(:parking_registration).permit( :first_name, :last_name, :email, :spot_number )
  end
end
