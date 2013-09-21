class ParkingRegistrationsController < ApplicationController
  def new
    @parking_registration = ParkingRegistration.new
  end

  def create
    @parking_registration = ParkingRegistration.new( parking_registration_params )

    if @parking_registration.park
      flash[:notice] = 'You registered successfully'
      session[:user_id] = @parking_registration.id
      redirect_to parking_registration_path( @parking_registration )
    else
      render :new
    end
  end

  def show
    @parking_registration = ParkingRegistration.find( params[:id] )
    @neighbors = @parking_registration.neighbors
  end

  private
  def parking_registration_params
    params.require(:parking_registration).permit( :first_name, :last_name, :email, :spot_number )
  end
end
