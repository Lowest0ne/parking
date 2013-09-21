require 'spec_helper'

feature 'user can see neighbors',%Q{
  As a parker
  I want to see my two neighbors
  So that I can get to know them better
} do

# Acceptance Criteria
# * After checking in, if I have a neighbor in a slot 1 below me,
# *   or one above me, I am informed of their name and what slot
# *   number they are currently in
# * If I do not have anyone parking next to me,
# *   I am told that I have no current neighbors

  scenario 'parker has no neighbors' do
    registration = FactoryGirl.build( :parking_registration )

    visit root_path

    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Email', with: 'example@example.com'
    fill_in 'Spot number', with: '1'

    click_on 'Register'


    page.should have_content('You have no neighbors')

  end

  scenario 'parker has two neighbors' do

    FactoryGirl.create( :parking_registration, spot_number: 1 )
    FactoryGirl.create( :parking_registration, spot_number: 3, first_name: 'm' )

    visit root_path

    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Email', with: 'example@example.com'
    fill_in 'Spot number', with: '2'

    click_on 'Register'

    page.should have_content('Your neighbors are')
    page.should have_content('John Smith is parked at spot number: 1')
    page.should have_content('m Smith is parked at spot number: 3')

    page.should_not have_content('You have no neighbors')
  end
end
