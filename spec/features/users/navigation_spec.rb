# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a User' do
  describe 'as a Registered User' do
    it "has profile and logout links but doesn't have login or register links" do
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

      visit welcome_path

      within 'nav' do
        expect(page).to have_content('Logged in as:')

        click_link 'Bob'
      end

      expect(current_path).to eq('/profile')

      within 'nav' do
        expect(page).to_not have_link('Register')
        expect(page).to_not have_link('Log In')
      end

      within 'nav' do
        click_link 'Log Out'
      end

      expect(current_path).to eq(welcome_path)
    end

    it 'restricts access to merchant and admin dashboards' do
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

      visit admin_path

      expect(current_path).to eq(admin_path)
      expect(page).to have_content('The page you were looking for doesn\'t exist.')

      visit merchant_dashboard_path

      expect(current_path).to eq(merchant_dashboard_path)
      expect(page).to have_content('The page you were looking for doesn\'t exist.')
    end
  end

  describe 'as a non-registered user' do
    it "doesn't have access to merchant dashboard, admin dashboard, or profile" do
      visit admin_path

      expect(current_path).to eq(admin_path)
      expect(page).to have_content('The page you were looking for doesn\'t exist.')

      visit merchant_dashboard_path

      expect(current_path).to eq(merchant_dashboard_path)
      expect(page).to have_content('The page you were looking for doesn\'t exist.')

      visit profile_path

      expect(current_path).to eq(profile_path)
      expect(page).to have_content('The page you were looking for doesn\'t exist.')

      within 'nav' do
        expect(page).to_not have_link('Merchant Dashboard')
        expect(page).to_not have_link('Admin Dashboard')
        expect(page).to_not have_content('Logged in as:')
      end
    end
  end
end
