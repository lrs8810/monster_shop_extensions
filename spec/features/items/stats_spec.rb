# frozen_string_literal: true

require 'rails_helper'

describe 'Items Index Page' do
  describe 'When I visit the items index page' do
    before(:each) do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_233)

      @tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      @pump = meg.items.create(name: 'Bike Pump', description: 'It works fast!', price: 25, image: 'https://images-na.ssl-images-amazon.com/images/I/71Wa47HMBmL._SY550_.jpg', inventory: 15)
      @helmet = meg.items.create(name: 'Helmet', description: 'It works fast!', price: 25, image: 'https://images-na.ssl-images-amazon.com/images/I/71Wa47HMBmL._SY550_.jpg', inventory: 15)
      @chain = meg.items.create(name: 'Chain', description: 'It works fast!', price: 25, image: 'https://images-na.ssl-images-amazon.com/images/I/71Wa47HMBmL._SY550_.jpg', inventory: 15)
      @lock = meg.items.create(name: 'Lock', description: 'It works fast!', price: 25, image: 'https://images-na.ssl-images-amazon.com/images/I/71Wa47HMBmL._SY550_.jpg', inventory: 15)
      @seat = meg.items.create(name: 'Seat', description: 'It works fast!', price: 25, image: 'https://images-na.ssl-images-amazon.com/images/I/71Wa47HMBmL._SY550_.jpg', inventory: 15)

      user = User.create!(name: 'Bob',
                          address: '123 Main',
                          city: 'Denver',
                          state: 'CO',
                          zip: 80_233,
                          email: 'bob@email.com',
                          password: 'secure')

      order = user.orders.create(name: 'Bob', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233)

      ItemOrder.create(order_id: order.id, item_id: @tire.id, quantity: 12, price: 100)
      ItemOrder.create(order_id: order.id, item_id: @pump.id, quantity: 3, price: 20)
      ItemOrder.create(order_id: order.id, item_id: @helmet.id, quantity: 8, price: 20)
      ItemOrder.create(order_id: order.id, item_id: @chain.id, quantity: 6, price: 20)
      ItemOrder.create(order_id: order.id, item_id: @lock.id, quantity: 10, price: 20)
      ItemOrder.create(order_id: order.id, item_id: @seat.id, quantity: 1, price: 20)

      visit items_path
    end

    it 'I see the most and least popular items and the quantity sold' do
      within '#most-popular-items' do
        expect(page).to have_content('Most Popular Items:')
        expect(page).to have_content("#{@tire.name}: 12 purchased\n#{@lock.name}: 10 purchased\n#{@helmet.name}: 8 purchased\n#{@chain.name}: 6 purchased\n#{@pump.name}: 3 purchased")
        expect(page).to_not have_content(@seat.name)
      end

      within '#least-popular-items' do
        expect(page).to have_content('Least Popular Items:')
        expect(page).to have_content("#{@seat.name}: 1 purchased\n#{@pump.name}: 3 purchased\n#{@chain.name}: 6 purchased\n#{@helmet.name}: 8 purchased\n#{@lock.name}: 10 purchased")
        expect(page).to_not have_content(@tire.name)
      end
    end
  end
end
