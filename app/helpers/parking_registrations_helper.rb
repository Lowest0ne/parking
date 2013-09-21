module ParkingRegistrationsHelper

  def current_email
    return nil unless session[:user_id]

    ParkingRegistration.find( session[:user_id] ).email
  end

end
