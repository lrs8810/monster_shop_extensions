# frozen_string_literal: true

require 'rails_helper'

describe 'User Registration' do
  it 'there is a registration page and form to create a new user' do
    visit welcome_path

    within 'nav' do
      click_link 'Register'
    end

    expect(current_path).to eq(register_path)

    fill_in :name, with: 'Bob'
    fill_in :address, with: '123 Main'
    fill_in :city, with: 'Denver'
    fill_in :state, with: 'CO'
    fill_in :zip, with: 80_233
    fill_in :email, with: 'bob@email.com'
    fill_in :password, with: 'password'
    fill_in :password_confirmation, with: 'password'

    click_button 'Create User'

    expect(current_path).to eq(profile_path)
    expect(page).to have_content('Welcome, Bob! You are now logged in and registered.')
  end

  it 'as a new user I must fill out entire form' do
    visit register_path

    click_button 'Create User'

    expect(page).to have_content('Name can\'t be blank')
    expect(page).to have_content('Address can\'t be blank')
    expect(page).to have_content('City can\'t be blank')
    expect(page).to have_content('State can\'t be blank')
    expect(page).to have_content('Zip can\'t be blank')
    expect(page).to have_content('Email can\'t be blank')
    expect(page).to have_content('Password can\'t be blank')
    expect(page).to have_content('Password digest can\'t be blank')
  end

  it 'as a new user I must register with a unique email address' do
    User.create!(name: 'Bob', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, email: 'bob@email.com', password: 'secure')

    visit register_path

    fill_in :name, with: 'Bob'
    fill_in :address, with: '542 Oak Ave'
    fill_in :city, with: 'Boulder'
    fill_in :state, with: 'Colorado'
    fill_in :zip, with: 80_001
    fill_in :email, with: 'bob@email.com'
    fill_in :password, with: 'password'
    fill_in :password_confirmation, with: 'password'

    click_button 'Create User'

    expect(page).to have_content('Email has already been taken')

    expect(find_field(:name).value).to eq('Bob')
    expect(find_field(:address).value).to eq('542 Oak Ave')
    expect(find_field(:city).value).to eq('Boulder')
    expect(find_field(:state).value).to eq('Colorado')
    expect(find_field(:zip).value).to eq('80001')
    expect(find_field(:email).value).to eq(nil)
    expect(find_field(:password).value).to eq(nil)
    expect(find_field(:password_confirmation).value).to eq(nil)
  end
end
