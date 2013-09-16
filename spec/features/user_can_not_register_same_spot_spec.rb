require 'spec_helper'

feature 'a user can not register a spot that has already been taken', %Q{
  As a parker
  I cannot check in to a spot that has already been checked in
  So that two cars are not parked in the same spot
} do

  scenario 'the spot is already taken' do

    registration = FactoryGirl.build( :parking_registration, parked_on: nil )
    registration.park

    visit root_path

    fill_in 'First name', with: 'a different first name'
    fill_in 'Last name', with: 'a different last name'
    fill_in 'Email', with: 'different@example.com'
    fill_in 'Spot number', with: registration.spot_number

    click_on 'Register'

    expect(page).to have_content('Spot number is already taken')
  end
end
