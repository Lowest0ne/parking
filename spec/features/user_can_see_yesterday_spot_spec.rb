require 'spec_helper'

feature "user can see the spot he/she parked in yesterday", %Q{
  As a parker
  I want to know what spot I parked in yesterday
  So that I can determine if I'm parking in the same spot
} do

  scenario "I can see yesterday's spot if I parked yesterday" do

    date_today = Date.today
    yesterday_registration = FactoryGirl.create( :parking_registration, parked_on: date_today - 1 )
    today_registration = FactoryGirl.build( :parking_registration, parked_on: date_today )

    visit root_path
    fill_in 'First name', with: today_registration.first_name
    fill_in 'Last name', with: today_registration.last_name
    fill_in 'Email', with: today_registration.email
    fill_in 'Spot number', with: today_registration.spot_number

    click_on 'Register'

    expect( today_registration.parked_on ).to eql( yesterday_registration.parked_on + 1 )
    expect( today_registration.spot_number ).to eql( yesterday_registration.spot_number )
    page.should have_content( "Yesterday you parked on spot ##{yesterday_registration.spot_number}" )

  end

end
