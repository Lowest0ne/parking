class ParkingRegistration::HistoriesController < ApplicationController
  def show
    @parking_registration = ParkingRegistration.find( params[:id] )
  end
end
