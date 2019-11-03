# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a User' do
  describe 'when I click login, I enter an email and password' do
    before(:each) do
      visit welcome_path
      click_link 'Log In'
      expect(current_path).to eq(login_path)
    end

    it 'cannot login with invalid password' do
      user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )

      fill_in :email, with: user.email
      fill_in :password, with: 'not secure'

      click_on 'Sign me in'

      expect(page).to have_content('The email and password you entered did not match our records. Please double-check and try again.')
      expect(find_field(:email).value).to eq(nil)
      expect(find_field(:password).value).to eq(nil)
    end

    it 'cannot login with invalid email' do
      user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )

      fill_in :email, with: 'not_bob@email.com'
      fill_in :password, with: user.password

      click_on 'Sign me in'

      expect(page).to have_content('The email and password you entered did not match our records. Please double-check and try again.')
      expect(find_field(:email).value).to eq(nil)
      expect(find_field(:password).value).to eq(nil)
    end

    it 'cannot login if the user is disabled' do
      user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure',
        enabled?: false
      )

      fill_in :email, with: user.email
      fill_in :password, with: user.password

      click_on 'Sign me in'

      expect(page).to have_content("Your user account is disabled!")
      expect(find_field(:email).value).to eq(nil)
      expect(find_field(:password).value).to eq(nil)
    end

    describe 'as a regular user' do
      it 'when I enter my valid credentials, I am redirected to my profile page' do
        user = User.create(
          name: 'Bob',
          address: '123 Main',
          city: 'Denver',
          state: 'CO',
          zip: 80_233,
          email: 'bob@email.com',
          password: 'secure'
        )

        fill_in :email, with: user.email
        fill_in :password, with: user.password

        click_on 'Sign me in'

        expect(current_path).to eq(profile_path)
        expect(page).to have_content("Welcome back, #{user.name}!")
        expect(page).to have_link('Log Out')
        expect(page).to_not have_link('Register')
        expect(page).to_not have_link('Log In')
      end

      it 'redirects me to the appropriate profile if Im already logged in' do
        user = User.create(
          name: 'Bob',
          address: '123 Main',
          city: 'Denver',
          state: 'CO',
          zip: 80_233,
          email: 'bob@email.com',
          password: 'secure'
        )

        fill_in :email, with: user.email
        fill_in :password, with: user.password

        click_on 'Sign me in'

        visit login_path

        expect(current_path).to eq(profile_path)
        expect(page).to have_content('You are already logged in!')
      end
    end

    describe 'as a merchant employee or merchant admin' do
      it 'when I enter my valid credentials, I am redirected to my merchant dashboard' do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        merchant_employee = meg.users.create!(
          name: 'Bob',
          address: '123 Main',
          city: 'Denver',
          state: 'CO',
          zip: 80_233,
          email: 'bob@email.com',
          password: 'secure',
          role: 1
        )

        fill_in :email, with: merchant_employee.email
        fill_in :password, with: merchant_employee.password

        click_on 'Sign me in'

        expect(current_path).to eq(merchant_dashboard_path)
        expect(page).to have_content("Welcome back, #{merchant_employee.name}!")
        expect(page).to have_link('Log Out')
        expect(page).to_not have_link('Register')
        expect(page).to_not have_link('Log In')
      end

      it 'redirects me to the merchant dashboard if Im already logged in' do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        merchant_admin = meg.users.create!(
          name: 'Bob',
          address: '123 Main',
          city: 'Denver',
          state: 'CO',
          zip: 80_233,
          email: 'bob@email.com',
          password: 'secure',
          role: 2
        )

        fill_in :email, with: merchant_admin.email
        fill_in :password, with: merchant_admin.password

        click_on 'Sign me in'

        visit login_path

        expect(current_path).to eq(merchant_dashboard_path)
        expect(page).to have_content('You are already logged in!')
      end
    end

    describe 'as a site admin' do
      it 'when I enter my valid credentials, I am redirected to my site admin dashboard' do
        site_admin = User.create(
          name: 'Bob',
          address: '123 Main',
          city: 'Denver',
          state: 'CO',
          zip: 80_233,
          email: 'bob@email.com',
          password: 'secure',
          role: 3
        )

        fill_in :email, with: site_admin.email
        fill_in :password, with: site_admin.password

        click_on 'Sign me in'

        expect(current_path).to eq(admin_path)
        expect(page).to have_content("Welcome back, #{site_admin.name}!")
        expect(page).to have_link('Log Out')
        expect(page).to_not have_link('Register')
        expect(page).to_not have_link('Log In')
      end
    end

    it 'redirects me to the site admin dashboard if Im already logged in' do
      site_admin = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure',
        role: 3
      )

      fill_in :email, with: site_admin.email
      fill_in :password, with: site_admin.password

      click_on 'Sign me in'

      visit login_path

      expect(current_path).to eq(admin_path)
      expect(page).to have_content('You are already logged in!')
    end
  end
end
