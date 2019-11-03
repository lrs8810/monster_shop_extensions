# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As an admin' do
  it 'has a link to the admin dashboard' do
    admin = User.create(
      name: 'Bob',
      address: '123 Main',
      city: 'Denver',
      state: 'CO',
      zip: 80_233,
      email: 'bob@email.com',
      password: 'secure',
      role: 3
    )

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit welcome_path

    within 'nav' do
      click_link 'Admin Dashboard'
    end

    expect(current_path).to eq('/admin')

    within 'nav' do
      click_link 'Users'
    end

    expect(current_path).to eq('/admin/users')

    within 'nav' do
      expect(page).to_not have_link('Cart')
    end
  end

  it 'does not have access to cart or merchant' do
    admin = User.create(
      name: 'Bob',
      address: '123 Main',
      city: 'Denver',
      state: 'CO',
      zip: 80_233,
      email: 'bob@email.com',
      password: 'secure', role: 3
    )

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit merchant_dashboard_path

    expect(current_path).to eq(merchant_dashboard_path)
    expect(page).to have_content('The page you were looking for doesn\'t exist.')

    visit cart_path

    expect(current_path).to eq(cart_path)
    expect(page).to have_content('The page you were looking for doesn\'t exist.')
  end
end
