require 'rails_helper'

RSpec.describe 'As an admin user' do
  describe 'when I visit a specific users profile page ' do
    it 'it shows the same info the user would see on their profile page' do
      user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )

      site_admin = User.create(
        name: 'Site Admin',
        address: '123 First',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'site_admin@user.com',
        password: 'secure',
        role: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(site_admin)

      visit "/admin/users/#{user.id}"

      within '#user-info' do
        expect(page).to have_content('Name: Bob')
        expect(page).to have_content('Address: 123 Main')
        expect(page).to have_content('City: Denver')
        expect(page).to have_content('State: CO')
        expect(page).to have_content('Zip: 80233')
        expect(page).to have_content('Email: bob@email.com')
        expect(page).to have_link('Edit Profile')
        expect(page).to_not have_link('Edit Password')
      end
    end
  end
end
