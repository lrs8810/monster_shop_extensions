# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a merchant' do
  describe 'merchant admin' do
    describe 'when I click edit item from the merchant items index page' do
      before :each do
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100.25, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
        merchant_admin = @meg.users.create!(
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

        within "#item-#{@tire.id}" do
          click_link 'Edit'
        end
      end

      it 'has a prepopulated form with the previous values' do
        expect(current_path).to eq(merchant_items_edit_path(@tire.id))

        expect(find_field('Name').value).to eq('Gatorskins')
        expect(find_field('Price').value).to eq('100.25')
        expect(find_field('Description').value).to eq("They'll never pop!")
        expect(find_field('Image').value).to eq('https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588')
        expect(find_field('Inventory').value).to eq('12')
      end

      it 'can edit an item from the edit item form' do
        fill_in :name, with: 'Chamois Buttr'
        fill_in :price, with: 18
        fill_in :description, with: "No more chaffin'!"
        fill_in :image, with: 'https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg'
        fill_in :inventory, with: 25

        click_button 'Update Item'

        expect(current_path).to eq(merchant_user_items_path)

        @tire.reload

        expect(page).to have_content('Item was successfully updated!')

        expect(@tire.name).to eq('Chamois Buttr')
        expect(@tire.price).to eq(18)
        expect(@tire.description).to eq("No more chaffin'!")
        expect(@tire.image).to eq('https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg')
        expect(@tire.inventory).to eq(25)
        expect(@tire.active?).to eq(true)
      end

      it 'must have both price and inventory greater than zero for item creation' do
        fill_in :name, with: 'Chamois Buttr'
        fill_in :price, with: -1
        fill_in :description, with: "No more chaffin'!"
        fill_in :image, with: 'https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg'
        fill_in :inventory, with: -1

        click_button 'Update Item'

        expect(page).to have_content('Price must be greater than 0')
        expect(page).to have_content('Inventory must be greater than 0')
      end

      it 'forms cannot be left blank' do
        fill_in :name, with: nil
        fill_in :price, with: 5
        fill_in :description, with: nil
        fill_in :image, with: 'https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg'
        fill_in :inventory, with: 5

        click_button 'Update Item'

        expect(page).to have_content('Name can\'t be blank')
        expect(page).to have_content('Description can\'t be blank')
      end
    end
  end
end
