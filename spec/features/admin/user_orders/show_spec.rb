require 'rails_helper'

RSpec.describe 'As an Admin User' do
  describe 'when I visit a user\'s profile' do
    it 'I can click a link and view the user\'s order show page' do
      user_1 = User.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, email: 'user_1@user.com', password: 'secure', role: 0)
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '125 Bike St.', city: 'Denver', state: 'CO', zip: 80_210)
      tire = bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      pull_toy = dog_shop.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)
      order_1 = user_1.orders.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, status: 2)
      item_order_1 = order_1.item_orders.create(order_id: order_1.id, item_id: tire.id, quantity: 2, price: 15, merchant_id: bike_shop.id)
      item_order_2 = order_1.item_orders.create(order_id: order_1.id, item_id: pull_toy.id, quantity: 1, price: 100, merchant_id: dog_shop.id)

      site_admin = User.create(name: 'Site Admin', address: '123 First', city: 'Denver', state: 'CO', zip: 80_233, email: 'site_admin@user.com', password: 'secure', role: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(site_admin)

      visit "/admin/users/#{user_1.id}"

      within '#user-order-links' do
        click_on "#{order_1.id}"
      end

      expect(current_path).to eq(admin_user_order_path(user_1.id, order_1.id))

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

    describe 'then click a link to visit a user\'s order show page' do
      it 'it displays a link to cancel an order that is Pending' do
        user_1 = User.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, email: 'user_1@user.com', password: 'secure', role: 0)
        dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
        bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '125 Bike St.', city: 'Denver', state: 'CO', zip: 80_210)
        tire = bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
        pull_toy = dog_shop.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)
        order_1 = user_1.orders.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, status: 0)
        item_order_1 = order_1.item_orders.create(order_id: order_1.id, item_id: tire.id, quantity: 2, price: 15, merchant_id: bike_shop.id, status: 1)
        item_order_2 = order_1.item_orders.create(order_id: order_1.id, item_id: pull_toy.id, quantity: 1, price: 100, merchant_id: dog_shop.id, status: 0)

        site_admin = User.create(name: 'Site Admin', address: '123 First', city: 'Denver', state: 'CO', zip: 80_233, email: 'site_admin@user.com', password: 'secure', role: 3)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(site_admin)

        visit "/admin/users/#{user_1.id}/orders/#{order_1.id}"

        within '#order-info' do
          click_link 'Cancel Order'
        end

        expect(current_path).to eq(admin_users_path(user_1.id))
        expect(page).to have_content('Order has been cancelled!')

        tire.reload
        order_1.reload
        item_order_1.reload
        item_order_2.reload

        expect(tire.inventory).to eq(14)
        expect(pull_toy.inventory).to eq(32)
        expect(order_1.status).to eq('Cancelled')
        expect(item_order_1.status).to eq('Unfulfilled')
        expect(item_order_2.status).to eq('Unfulfilled')
      end

      it 'it does not display a link to cancel an order that is Packaged' do
        user_1 = User.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, email: 'user_1@user.com', password: 'secure', role: 0)
        dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
        bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '125 Bike St.', city: 'Denver', state: 'CO', zip: 80_210)
        tire = bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
        pull_toy = dog_shop.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)
        order_1 = user_1.orders.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, status: 1)
        item_order_1 = order_1.item_orders.create(order_id: order_1.id, item_id: tire.id, quantity: 2, price: 15, merchant_id: bike_shop.id, status: 1)
        item_order_2 = order_1.item_orders.create(order_id: order_1.id, item_id: pull_toy.id, quantity: 1, price: 100, merchant_id: dog_shop.id, status: 1)

        site_admin = User.create(name: 'Site Admin', address: '123 First', city: 'Denver', state: 'CO', zip: 80_233, email: 'site_admin@user.com', password: 'secure', role: 3)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(site_admin)

        visit "/admin/users/#{user_1.id}/orders/#{order_1.id}"

        within '#order-info' do
          expect(page).to_not have_link('Cancel Order')
        end
      end
    end
  end
end
