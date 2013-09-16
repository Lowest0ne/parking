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
    self.parked_on = Date.today

    if ParkingRegistration.find_by( spot_number: spot_number ) == nil
      save
    else
      errors.add(:spot_number, 'is already taken')
      false
    end
  end

end
