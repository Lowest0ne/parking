class ParkingRegistration < ActiveRecord::Base

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_presence_of :spot_number
  validates_presence_of :parked_on

  validates_format_of :email, with: /[A-Z0-9.&+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i

  validates_numericality_of :spot_number,
    only_integer: true,
    greater_than: 0,
    less_than_or_equal_to: 60

  def park
    self.parked_on ||= Date.today

    if ParkingRegistration.is_available?( spot_number )
      save
    else
      errors.messages[:parked_on] ||= []
      errors.messages[:parked_on] << 'Spot number is already taken'
      false
    end
  end

  def self.is_available? spot
    ParkingRegistration.find_by( spot_number: spot, parked_on: Date.today ).nil?
  end

  def neighbors
    neighbors = ParkingRegistration.where(
      "(spot_number = :below OR spot_number = :above)
       AND parked_on = :parked_on",
       {
         below: self.spot_number - 1,
         above: self.spot_number + 1,
         parked_on: self.parked_on
      }).order( :spot_number ).to_a


  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def spot_yesterday
    ParkingRegistration.find_by(
      "first_name = :first_name AND
       last_name  = :last_name AND
       email      = :email AND
       parked_on  = :parked_on",
       {
         first_name: self.first_name,
         last_name: self.last_name,
         email: self.email,
         parked_on: self.parked_on - 1
       }
    )
  end



end
