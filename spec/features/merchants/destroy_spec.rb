# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As an admin user' do
  describe 'When I visit a merchant show page' do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80_203)
      @site_admin = User.create(name: 'Site Admin', address: '123 First', city: 'Denver', state: 'CO', zip: 80_233, email: 'site_admin@user.com', password: 'secure', role: 3)
      @chain = @bike_shop.items.create(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@site_admin)

      visit "merchants/#{@bike_shop.id}"
    end

    it 'I can delete a merchant' do
      click_on 'Delete Merchant'

      expect(current_path).to eq(merchants_path)
      expect(page).to_not have_content("Brian's Bike Shop")
    end

    it 'I can delete a merchant that has items' do
      click_on 'Delete Merchant'

      expect(current_path).to eq(merchants_path)
      expect(page).to_not have_content("Brian's Bike Shop")
    end

    it "I can't delete a merchant that has orders" do
      user = User.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, email: 'user_1@user.com', password: 'secure', role: 0)
      order = user.orders.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, status: 2)
      item_order = order.item_orders.create(order_id: order.id, item_id: @chain.id, quantity: 1, price: 50, merchant_id: @bike_shop.id)

      @site_admin = User.create(name: 'Site Admin', address: '123 First', city: 'Denver', state: 'CO', zip: 80_233, email: 'site_admin@user.com', password: 'secure', role: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@site_admin)

      visit "/merchants/#{@bike_shop.id}"
      expect(page).to_not have_link('Delete Merchant')
    end
  end
end
