module ParkingRegistrationsHelper

  def current_user
    return nil unless session[:user_id]

    ParkingRegistration.find( session[:user_id] )
  end

end
