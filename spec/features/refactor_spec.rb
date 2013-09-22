require 'spec_helper'

feature 'parker registers spot', %Q{
  As a parker
  I want to register my spot with my name
  so tht the parking company can identify my car
} do

  before(:each) do
    @registration = FactoryGirl.build( :parking_registration )
    visit root_path
  end

  # Acceptance Criteria:
  #
  # * I must enter a first name, last name, email, and parking spot number
  # * I must enter a valid parking spot ( 1 - 60 )
  # * I must enter a valid email
  #
  # * If I specify a parking spot that has already been taken that day,
  #   I am told I can't check in there.
  # * If I specify a spot that hasn't yet been parked in today
  #   I am able to check in.

  scenario 'with valid information' do

    prev_count = ParkingRegistration.count
    register( @registration )

    expect( ParkingRegistration.count ).to eql( prev_count + 1 )

    page.should have_content('Successful Registration')

    register( @registration )
    expect( ParkingRegistration.count ).to eql( prev_count + 1 )
    page.should_not have_content('Successful Registration')
    page.should have_content('is already taken')

  end

  scenario 'with invalid information' do
    prev_count = ParkingRegistration.count
    click_on 'Register'
    expect( ParkingRegistration.count ).to eql( prev_count )
  end

end

feature 'parker can see neighbors', %Q{
  As a parker
  I want to see my two neighbors
  So that I can get to know them better
} do
  # Acceptance Criteria:
  #
  # * After checking in, if I have a neighbor next to me,
  #   I am informed of their name and what slot number they are in
  # * If I do not have a neighbor, I am told that I have no neighbors
  scenario "I see everything I should" do
    registration = FactoryGirl.build( :parking_registration )

    registration.first_name = 'FirstRegistration'
    register( registration )
    page.should have_content('You have no neighbors')

    registration.first_name = 'SecondRegistration'
    registration.spot_number += 1
    register( registration )

    page.should_not have_content('You have no neighbors')
    page.should have_content( 'FirstRegistration' )
    page.should have_content( "#{registration.spot_number - 1}")

    registration.first_name = 'ThirdRegistration'
    registration.spot_number += 3
    register( registration )
    page.should have_content('You have no neighbors')

    registration.first_name = 'FourthRegistration'
    registration.spot_number -= 1
    register( registration )
    page.should have_content('ThirdRegistration')
    page.should have_content("#{registration.spot_number + 1}")

    registration.first_name = 'FifthRegistration'
    registration.spot_number -= 1
    register( registration )
    page.should have_content('SecondRegistration')
    page.should have_content('FourthRegistration')
  end
end

feature "the system remembers parker's email",%Q{
  As a parker
  I want the system to remember my email
  So that I don't have to re-enter it
}

# Acceptance Criteria:
#
# * If I have previously checked in via the same web browser,
#     my email is remembered so that I don't have to re-enter it
# * If I have not previously checked in, the email address field is left blank

feature "the system rememers parker's previous spot",%Q{
  As a parker
  I want to know what spot I parked in yesterday
  So that I can determine if I'm parking in the same spot
}do
  # Acceptance Criteria:
  #
  # * If I parked yesterday, the system tells me where I parked
  # * If I did not park yesterday, the system tells me so
  scenario "I can see my email when I try to register again" do
    registration = FactoryGirl.build( :parking_registration )
    register( registration )
    visit root_path
    find_field('parking_registration_email').value.should eql( registration.email )
  end
end

feature 'the system suggests my last parking space', %Q{
  As a parker
  I want the system to suggest the last spot I parked in
  So that I don't have to re-enter the slot number
}do

  # Acceptance Criteria:
  #
  # * If I parked before today, the system prefills my spot number
  #     with the spot I last parked in.
  # * If I have not parked, the system does not prefill the spot number.
  scenario "I have never parked before" do
    visit root_path
    find_field('parking_registration_spot_number').value.should eql(nil)
  end

  scenario "I have parked before" do
    registration = FactoryGirl.build( :parking_registration )
    register( registration )
    visit root_path
    find_field('parking_registration_spot_number').value.should eql(registration.spot_number.to_s)
  end
end

feature 'parker can view parking history', %Q{
  As a parker
  I want to see a list of my parking activity
  So that I can see where I've parked over time
}do

  # Acceptance Criteria:
  #
  # * When checking in, if I've previously checked in with the same email,
  #     I am given the option to see parking activity
  # * If I opt to see parking activity, I am shown all of my check-ins sorted in
  #     reverse chronological order. I can see the spot number and the day and
  #     time I checked in.
  # * If I have not previously checked in, I do not have the option to see
  #     my parking activity
  scenario "I have never checked in" do
    registration = FactoryGirl.build( :parking_registration )
    register( registration )
    page.should_not have_content('View History')
  end

  scenario "I have checked in before" do
    registration = FactoryGirl.build( :parking_registration )
    register( registration )
    registration.spot_number += 1
    register( registration )

    click_on 'View History'
    page.should have_content( "#{registration.spot_number - 1}" )
  end
end
