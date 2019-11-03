require 'rails_helper'

RSpec.describe 'As an admin user' do
  describe 'when I visit a user\'s profile page' do
    before(:each) do
      @user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )

      @site_admin = User.create(
        name: 'Site Admin',
        address: '123 First',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'site_admin@user.com',
        password: 'secure',
        role: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@site_admin)
    end

    it 'I can click on a link to edit that user\'s profile data' do
      visit "/admin/users/#{@user.id}"

      within '#user-info' do
        click_on 'Edit Profile'
      end

      expect(current_path).to eq("/admin/users/#{@user.id}/edit")
    end

    it 'is prepopulated with that user\'s previous data' do
      visit "/admin/users/#{@user.id}/edit"

      expect(find_field(:name).value).to eq(@user.name)
      expect(find_field(:address).value).to eq(@user.address)
      expect(find_field(:city).value).to eq(@user.city)
      expect(find_field(:state).value).to eq(@user.state)
      expect(find_field(:zip).value).to eq(@user.zip)
      expect(find_field(:email).value).to eq(@user.email)
    end

    it 'edited data shows on the profile page' do
      visit "/admin/users/#{@user.id}/edit"

      fill_in :name, with: 'Bob'
      fill_in :address, with: '542 Oak Ave'
      fill_in :city, with: 'Boulder'
      fill_in :state, with: 'Colorado'
      fill_in :zip, with: 80_001
      fill_in :email, with: 'bob@email.com'

      click_button 'Update Profile'

      expect(current_path).to eq("/admin/users/#{@user.id}")

      expect(page).to have_content("#{@user.name}'s profile data has been updated!")

      within '#user-info' do
        expect(page).to have_content('Bob')
        expect(page).to have_content('542 Oak Ave')
        expect(page).to have_content('Boulder')
        expect(page).to have_content('Colorado')
        expect(page).to have_content('80001')
        expect(page).to have_content('bob@email.com')
      end
    end

    it 'cannot be edited with an email already in use' do
      user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'not_bob@email.com',
        password: 'secure'
      )

      visit "/admin/users/#{@user.id}/edit"

      fill_in :email, with: 'not_bob@email.com'

      click_button 'Update Profile'

      expect(page).to have_content('Email has already been taken')

      expect(find_field(:name).value).to eq(@user.name)
    end
  end
end
