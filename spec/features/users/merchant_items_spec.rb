# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a Merchant Admin' do
  before(:each) do
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
    @merchant_admin = @meg.users.create(
      name: 'Admin',
      address: '123 Main',
      city: 'Denver',
      state: 'CO',
      zip: 80_233,
      email: 'bobemail.com',
      password: 'secure',
      role: 2
    )
    @user = User.create!(
      name: 'User',
      address: '123 Main',
      city: 'Denver',
      state: 'CO',
      zip: 80_233,
      email: 'useremail.com',
      password: 'secure'
    )

    @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
    @pump = @meg.items.create(name: 'Bike Pump', description: 'It works fast!', price: 25, image: 'https://images-na.ssl-images-amazon.com/images/I/71Wa47HMBmL._SY550_.jpg', active?: false, inventory: 15)

    @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033, status: 'Pending')
    @order_2 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033, status: 'Pending')

    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)

    visit merchant_user_items_path
  end

  describe 'on my items page' do
    it 'I see a link to deactivate an active item' do
      within "#item-#{@pump.id}" do
        expect(page).to have_content('Inactive')
        expect(page).to_not have_link('Deactivate Item')
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_content('Active')
        expect(page).to have_link('Deactivate Item')
        click_link 'Deactivate Item'
      end

      expect(current_path).to eq(merchant_user_items_path)

      @tire.reload

      expect(page).to have_content("#{@tire.name} is now deactivated and is no longer for sale.")

      expect(@tire.active?).to eq(false)
    end

    it 'I see a link to activate an inactive item' do
      within "#item-#{@tire.id}" do
        expect(page).to have_content('Active')
        expect(page).to_not have_link('Activate Item')
      end

      within "#item-#{@pump.id}" do
        expect(page).to have_content('Inactive')
        expect(page).to have_link('Activate Item')
        click_link 'Activate Item'
      end

      expect(current_path).to eq(merchant_user_items_path)

      @pump.reload

      expect(page).to have_content("#{@pump.name} is now activated and available for sale.")

      expect(@pump.active?).to eq(true)
    end

    it 'I see a link to delete an item that has never been ordered' do
      within "#item-#{@tire.id}" do
        expect(page).to_not have_link('Delete Item')
      end

      within "#item-#{@pump.id}" do
        expect(page).to have_link('Delete Item')
        click_link 'Delete Item'
      end

      expect(current_path).to eq(merchant_user_items_path)

      expect(page).to have_content("#{@pump.name} is now removed from #{@meg.name}'s online inventory.")

      @pump.reload

      expect(@pump.enabled?).to eq(false)

      within '.grid-container' do
        expect(page).to have_content(@tire.name)
      end
    end
  end
end
