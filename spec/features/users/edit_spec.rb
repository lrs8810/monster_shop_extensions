# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a registered user' do
  describe 'when I visit the edit profile data form' do
    before :each do
      @user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_path

      within '#user-info' do
        click_link 'Edit Profile'
      end
    end

    it 'is prepopulated with my previous data' do
      expect(find_field(:name).value).to eq(@user.name)
      expect(find_field(:address).value).to eq(@user.address)
      expect(find_field(:city).value).to eq(@user.city)
      expect(find_field(:state).value).to eq(@user.state)
      expect(find_field(:zip).value).to eq(@user.zip)
      expect(find_field(:email).value).to eq(@user.email)
    end

    it 'edited data shows on the profile page' do
      fill_in :name, with: 'Bob'
      fill_in :address, with: '542 Oak Ave'
      fill_in :city, with: 'Boulder'
      fill_in :state, with: 'Colorado'
      fill_in :zip, with: 80_001
      fill_in :email, with: 'bob@email.com'

      click_button 'Update Profile'

      expect(current_path).to eq(profile_path)

      expect(page).to have_content('Your profile data has been updated!')

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

      fill_in :email, with: 'not_bob@email.com'

      click_button 'Update Profile'

      expect(page).to have_content('Email has already been taken')

      expect(find_field(:name).value).to eq(user.name)
    end
  end

  describe 'when I visit the edit password form' do
    it 'I see a link to edit my password' do
      user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path

      within '#user-info' do
        click_link 'Edit Password'
      end

      expect(current_path).to eq('/profile/edit_password')

      expect(find_field(:password).value).to eq(nil)
      expect(find_field(:password_confirmation).value).to eq(nil)
      fill_in :password, with: 'mystery'
      fill_in :password_confirmation, with: 'mystery'

      click_button 'Update Password'

      expect(current_path).to eq(profile_path)

      expect(page).to have_content('Your password has been updated successfully!')
    end

    it 'password cannot be updated if they do not match' do
      user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path

      within '#user-info' do
        click_link 'Edit Password'
      end

      expect(current_path).to eq('/profile/edit_password')

      fill_in :password, with: 'mystery'
      fill_in :password_confirmation, with: 'notmystery'

      click_button 'Update Password'

      expect(page).to have_content('Password confirmation doesn\'t match Password')
    end
  end
end
