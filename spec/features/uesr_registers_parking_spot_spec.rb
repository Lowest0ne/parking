require 'spec_helper'

feature "user registers spot", %Q{
  As a parker
  I want to register my spot with my name
  so tht the parking company can identify my car
} do

# Acceptance Criteria
# * I must enter a first name, last name, email, and parking spot number
# * I must enter a valid parking spot ( 1 - 60 )
# * I must enter a valid email

  scenario 'specifies valid information, registers spot' do

    prev_count = ParkingRegistration.count

    visit root_path
    fill_in 'First name', with: 'Carl'
    fill_in 'Last name', with: 'Schwope'
    fill_in 'Email', with: 'schwope.carl@gmail.com'
    fill_in 'Spot number', with: 5
    click_on 'Register'

    page.should have_content('You registered successfully')

    expect( ParkingRegistration.count ).to eql( prev_count + 1 )

  end
end


