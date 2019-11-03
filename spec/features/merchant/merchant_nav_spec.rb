# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a Merchant' do
  it 'employee or admin I see the merchant dashboard' do
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
    user = meg.users.create!(
      name: 'Bob',
      address: '123 Main',
      city: 'Denver',
      state: 'CO',
      zip: 80_233,
      email: 'bob@email.com',
      password: 'secure',
      role: 1
    )

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit welcome_path

    within 'nav' do
      click_link 'Merchant Dashboard'
    end

    expect(current_path).to eq('/merchant')
  end

  it 'employee or admin I do not have access to site admin dashboard' do
    merchant_employee = User.create(
      name: 'Bob',
      address: '123 Main',
      city: 'Denver',
      state: 'CO',
      zip: 80_233,
      email: 'bob@email.com',
      password: 'secure',
      role: 1
    )
    merchant_admin = User.create(
      name: 'Bob',
      address: '123 Main',
      city: 'Denver',
      state: 'CO',
      zip: 80_233,
      email: 'bob@email.com',
      password: 'secure',
      role: 2
    )

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

    visit admin_path

    expect(current_path).to eq(admin_path)
    expect(page).to have_content('The page you were looking for doesn\'t exist.')

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

    visit admin_path

    expect(current_path).to eq(admin_path)
    expect(page).to have_content('The page you were looking for doesn\'t exist.')
  end
end
