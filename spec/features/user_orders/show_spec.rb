# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a registered user' do
  describe 'When I visit a profile order show page' do
    it 'displays the order with all info' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)

      tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      pull_toy = brian.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)

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

      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)

      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)
      item_order_2 = order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3)

      visit profile_order_path(order_1)

      expect(page).to have_content("ID: #{order_1.id}")

      within '#order-info' do
        expect(page).to have_content("Date Created: #{order_1.created_at}")
        expect(page).to have_content("Last Updated: #{order_1.updated_at}")
        expect(page).to have_content("Status: #{order_1.status}")
        expect(page).to have_content("Total Quantity: #{order_1.total_quantity}")
        expect(page).to have_content("Grand Total: $#{order_1.grand_total}")
      end

      within "#item-order-#{item_order_1.id}" do
        expect(page).to have_content("Name: #{tire.name}")
        expect(page).to have_content("Description: #{tire.description}")
        expect(page).to have_css("img[src*='#{tire.image}']")
        expect(page).to have_content("Quantity: #{item_order_1.quantity}")
        expect(page).to have_content("Price: $#{item_order_1.price}")
        expect(page).to have_content("Subtotal: $#{item_order_1.subtotal}")
      end

      within "#item-order-#{item_order_2.id}" do
        expect(page).to have_content("Name: #{pull_toy.name}")
        expect(page).to have_content("Description: #{pull_toy.description}")
        expect(page).to have_css("img[src*='#{pull_toy.image}']")
        expect(page).to have_content("Quantity: #{item_order_2.quantity}")
        expect(page).to have_content("Price: $#{item_order_2.price}")
        expect(page).to have_content("Subtotal: $#{item_order_2.subtotal}")
      end
    end

    it 'renders a 404 if the show page does not exist' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)

      tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      pull_toy = brian.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)

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

      visit profile_order_path(999_999)

      expect(page).to have_content('The page you were looking for doesn\'t exist.')
    end

    it 'displays a link to cancel the order' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)

      tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      pull_toy = brian.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)

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

      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)

      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)
      item_order_2 = order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3, status: 1)

      visit profile_order_path(order_1)

      within '#order-info' do
        click_link 'Cancel Order'
      end

      expect(current_path).to eq(profile_path)
      expect(page).to have_content('Order has been cancelled!')

      pull_toy.reload
      order_1.reload
      item_order_1.reload
      item_order_2.reload

      expect(tire.inventory).to eq(12)
      expect(pull_toy.inventory).to eq(35)
      expect(order_1.status).to eq('Cancelled')
      expect(item_order_1.status).to eq('Unfulfilled')
      expect(item_order_2.status).to eq('Unfulfilled')
    end

    it 'does not display a link if the order is shipped or cancelled' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)

      tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      pull_toy = brian.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)

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

      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033, status: 2)

      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)
      item_order_2 = order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3, status: 1)

      visit profile_order_path(order_1)
      
      expect(page).to_not have_link('Cancel Order')
    end
  end
end
