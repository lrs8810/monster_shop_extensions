# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a registered user' do
  describe 'When I visit my profile orders page' do
    it 'displays every order I have made and their info' do
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

      order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)
      order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3)

      visit profile_orders_path

      within "#order-#{order_1.id}" do
        expect(page).to have_link("#{order_1.id}")
        expect(page).to have_content("Date Created: #{order_1.created_at}")
        expect(page).to have_content("Last Updated: #{order_1.updated_at}")
        expect(page).to have_content("Status: #{order_1.status}")
        expect(page).to have_content("Total Quantity: #{order_1.total_quantity}")
        expect(page).to have_content("Grand Total: $#{order_1.grand_total}")
      end
    end
  end
end
