require 'spec_helper'

feature "user has his/her email remembered when he/he registers", %Q{
  As a parker
  I want the system to remember my email
  So that I don't have to re-enter it
} do

  scenario "after registering, I don't have to type my email" do

    registration = FactoryGirl.build( :parking_registration )

    visit root_path

    find_field('parking_registration_email').value.should eql( nil )

    fill_in 'First name', with: registration.first_name
    fill_in 'Last name', with: registration.last_name
    fill_in 'Email', with: registration.email
    fill_in 'Spot number', with: registration.spot_number

    click_on 'Register'

    visit root_path

    find_field('parking_registration_email').value.should eql( registration.email )
  end

end
