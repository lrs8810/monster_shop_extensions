# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a User' do
  describe 'when logging out' do
    it 'takes me back to the home page and deletes cart contents' do
      visit login_path

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

      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)

      visit item_path(tire.id)
      click_on 'Add To Cart'

      click_link 'Log Out'

      expect(page).to have_content('You have successfully logged out!')

      expect(current_path).to eq(welcome_path)
      within 'nav' do
        expect(page).to have_link('Cart: 0')
        expect(page).to have_link('Log In')
        expect(page).to_not have_content('Logged in as:')
      end
    end
  end
end
