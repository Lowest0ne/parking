class ParkingRegistration < ActiveRecord::Base

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_presence_of :spot_number
  validates_presence_of :parked_on

end
