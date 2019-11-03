# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Order Update' do
  describe 'when all items in an order have been fulfilled by their merchants' do
    it 'order status changes from pending to packaged' do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 5)
      @pump = @meg.items.create(name: 'Bike Pump', description: 'It works fast!', price: 25, image: 'https://images-na.ssl-images-amazon.com/images/I/71Wa47HMBmL._SY550_.jpg', inventory: 15)

      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @paper = @mike.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
      @pencil = @mike.items.create(name: 'Yellow Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)

      @merchant_employee = @meg.users.create!(
        name: 'Other Bob',
        address: '123 Bike Rd.',
        city: 'Denver',
        state: 'CO',
        zip: 80_203,
        email: 'otherbob@email.com',
        password: 'secure',
        role: 1
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)

      @user = User.create!(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: '@user@email.com',
        password: 'secure'
      )

      @order = @user.orders.create!(name: 'Bob', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, status: 'Pending')

      ItemOrder.create!(order_id: @order.id, item_id: @tire.id, quantity: 3, price: 100, merchant_id: @meg.id)
      ItemOrder.create!(order_id: @order.id, item_id: @pump.id, quantity: 4, price: 25, merchant_id: @meg.id, status: 1)
      ItemOrder.create!(order_id: @order.id, item_id: @paper.id, quantity: 2, price: 20, merchant_id: @mike.id, status: 1)
      ItemOrder.create!(order_id: @order.id, item_id: @pencil.id, quantity: 3, price: 2, merchant_id: @mike.id, status: 1)

      expect(@order.status).to eq('Pending')

      visit merchant_orders_path(@order)

      within "#item-#{@tire.id}" do
        click_link 'Fulfill Order'
      end

      @order.reload

      expect(@order.status).to eq('Packaged')
    end
  end
end
