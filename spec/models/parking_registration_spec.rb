require 'spec_helper'

describe ParkingRegistration do

  it { should have_valid( :email ).when('user@example.com') }
  it { should_not have_valid( :email).when( nil, '', 'foo' ) }

  it { should validate_presence_of( :first_name ) }
  it { should validate_presence_of( :last_name  ) }

  it { should     have_valid( :spot_number ).when( 5, 20 )      }
  it { should_not have_valid( :spot_number ).when( nil, 0, 61 ) }

  it { should     have_valid( :parked_on ).when( Date.today ) }
  it { should_not have_valid( :parked_on ).when( nil, '' )    }

  describe 'parking' do
    it 'parks the car for one day' do
      registration = FactoryGirl.build(:parking_registration, parked_on: nil)
      expect(registration.park).to eql(true)
      expect(registration.parked_on).to eql(Date.today)
    end
  end

end
