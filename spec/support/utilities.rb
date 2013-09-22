
def register( parking_registration )
  visit root_path

  fill_in 'First name', with: parking_registration.first_name
  fill_in 'Last name', with: parking_registration.last_name
  fill_in 'Email', with: parking_registration.email
  fill_in 'Spot number', with: parking_registration.spot_number

  click_on 'Register'
end
