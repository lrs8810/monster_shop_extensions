require 'rails_helper'

RSpec.describe 'As an Admin User' do
  describe 'when I visit the merchant index page' do
    it 'clicking a merchant name redirects to an admin merchant show page idential to that merchants dashboard' do
      user = User.create!(
        name: 'User_bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'user@email.com',
        password: 'secure'
      )

      merchant = Merchant.create!(
        name: "Brian's Bike Shop",
        address: '123 Bike Rd.',
        city: 'Richmond',
        state: 'VA',
        zip: 23_137,
        )

      site_admin = User.create!(
        name: 'Site Admin',
        address: '123 First',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'site_admin@user.com',
        password: 'secure',
        role: 3)

      pump = merchant.items.create(name: 'Bike Pump', description: 'It works fast!', price: 25, image: 'https://images-na.ssl-images-amazon.com/images/I/71Wa47HMBmL._SY550_.jpg', inventory: 15)
      order = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033, status: 'Pending')
      order.item_orders.create!(item: pump, price: pump.price, quantity: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(site_admin)

      visit merchants_path

      click_link merchant.name

      expect(current_path).to eq("/admin/merchants/#{merchant.id}")

      within '#merchant_details' do
        expect(page).to have_content("Brian's Bike Shop")
        expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
      end

      within "#order-#{order.id}" do
        expect(page).to have_content("Order ID: #{order.id}")
        expect(page).to have_content("Date Created: #{order.created_at}")
        expect(page).to have_content("Total Quantity: #{order.total_quantity}")
        expect(page).to have_content("Grand Total: $#{order.grand_total}")
      end

      expect(page).to have_link('View Items')
    end
  end
end
