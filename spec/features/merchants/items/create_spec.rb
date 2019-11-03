# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a merchant' do
  describe 'merchant admin' do
    describe 'when I click add item from the merchant items index page' do
      it 'can create a new item from the new item form' do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        merchant_admin = meg.users.create!(
          name: 'Bob',
          address: '123 Main',
          city: 'Denver',
          state: 'CO',
          zip: 80_233,
          email: 'bob@email.com',
          password: 'secure',
          role: 2
        )
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

        visit merchant_user_items_path

        click_on 'Add New Item'

        expect(current_path).to eq(merchant_items_new_path)

        fill_in :name, with: 'Chamois Buttr'
        fill_in :price, with: 18
        fill_in :description, with: "No more chaffin'!"
        fill_in :image, with: 'https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg'
        fill_in :inventory, with: 25

        click_button 'Create Item'

        new_item = Item.last

        expect(new_item.name).to eq('Chamois Buttr')
        expect(new_item.price).to eq(18)
        expect(new_item.description).to eq("No more chaffin'!")
        expect(new_item.image).to eq('https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg')
        expect(new_item.inventory).to eq(25)
        expect(new_item.active?).to eq(true)

        expect(page).to have_content('Item was successfully created!')

        within "#item-#{Item.last.id}" do
          expect(page).to have_content('Chamois Buttr')
          expect(page).to have_content('Deactivate Item')
        end
      end

      it 'can create a new item without and image' do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        merchant_admin = meg.users.create!(
          name: 'Bob',
          address: '123 Main',
          city: 'Denver',
          state: 'CO',
          zip: 80_233,
          email: 'bob@email.com',
          password: 'secure',
          role: 2
        )
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

        visit merchant_user_items_path

        click_on 'Add New Item'

        expect(current_path).to eq(merchant_items_new_path)

        fill_in :name, with: 'Chamois Buttr'
        fill_in :price, with: 18
        fill_in :description, with: "No more chaffin'!"
        fill_in :image, with: nil
        fill_in :inventory, with: 25

        click_button 'Create Item'

        new_item = Item.last

        # Optional images?

        expect(new_item.name).to eq('Chamois Buttr')
        expect(new_item.price).to eq(18)
        expect(new_item.description).to eq("No more chaffin'!")
        expect(new_item.image).to eq('https://bit.ly/34a6p1g')
        expect(new_item.inventory).to eq(25)
        expect(new_item.active?).to eq(true)
      end

      it 'must have both price and inventory greater that zero for item creation' do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        merchant_admin = meg.users.create!(
          name: 'Bob',
          address: '123 Main',
          city: 'Denver',
          state: 'CO',
          zip: 80_233,
          email: 'bob@email.com',
          password: 'secure',
          role: 2
        )
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

        visit merchant_user_items_path

        click_on 'Add New Item'

        expect(current_path).to eq(merchant_items_new_path)

        fill_in :name, with: 'Chamois Buttr'
        fill_in :price, with: -1
        fill_in :description, with: "No more chaffin'!"
        fill_in :image, with: 'https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg'
        fill_in :inventory, with: -1

        click_button 'Create Item'

        expect(page).to have_content('Price must be greater than 0')
        expect(page).to have_content('Inventory must be greater than 0')
      end

      it 'forms cannot be left blank' do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        merchant_admin = meg.users.create!(
          name: 'Bob',
          address: '123 Main',
          city: 'Denver',
          state: 'CO',
          zip: 80_233,
          email: 'bob@email.com',
          password: 'secure',
          role: 2
        )
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

        visit merchant_user_items_path

        click_on 'Add New Item'

        expect(current_path).to eq(merchant_items_new_path)

        fill_in :name, with: nil
        fill_in :price, with: 5
        fill_in :description, with: nil
        fill_in :image, with: 'https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg'
        fill_in :inventory, with: 5

        click_button 'Create Item'

        expect(page).to have_content('Name can\'t be blank')
        expect(page).to have_content('Description can\'t be blank')
      end
    end
  end
end
