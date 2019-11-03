# frozen_string_literal: true

require 'rails_helper'

describe 'As a logged in Merchant (employee/admin)' do
  before(:each) do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
    @merchant_employee = @meg.users.create!(
      name: 'Bob',
      address: '123 Main',
      city: 'Denver',
      state: 'CO',
      zip: 80_233,
      email: 'bob@email.com',
      password: 'secure',
      role: 1
    )
    @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
    @pump = @meg.items.create(name: 'Bike Pump', description: 'It works fast!', price: 25, image: 'https://images-na.ssl-images-amazon.com/images/I/71Wa47HMBmL._SY550_.jpg', inventory: 15)
    @helmet = @meg.items.create(name: 'Helmet', description: 'Protects your brain. Try it!', price: 15, image: 'https://www.rei.com/media/product/1289320004', inventory: 20)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end
  
  it 'on my dashboard, I see the name and address of the merchant I work for' do
    visit merchant_dashboard_path

    within '#merchant_details' do
      expect(page).to have_content("Meg's Bike Shop")
      expect(page).to have_content("123 Bike Rd.\nDenver, CO 80203")
    end
  end

  it 'on my dashboard, I see a link to view my own items' do
    visit merchant_dashboard_path

    click_link 'View Items'

    expect(current_path).to eq(merchant_user_items_path)
  end

  it 'I see a list of pending orders with items I sell' do
    user = User.create!(
      name: 'User_bob',
      address: '123 Main',
      city: 'Denver',
      state: 'CO',
      zip: 80_233,
      email: 'user@email.com',
      password: 'secure'
    )

    order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033, status: 'Pending')
    order_2 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033, status: 'Pending')

    order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    order_1.item_orders.create!(item: @helmet, price: @helmet.price, quantity: 2)
    order_2.item_orders.create!(item: @pump, price: @pump.price, quantity: 3)

    visit merchant_dashboard_path

    within "#order-#{order_1.id}" do
      expect(page).to have_link("#{order_1.id}")
      expect(page).to have_content("Date Created: #{order_1.created_at}")
      expect(page).to have_content("Total Quantity: #{order_1.total_quantity}")
      expect(page).to have_content("Grand Total: $#{order_1.grand_total}")
    end

    within "#order-#{order_2.id}" do
      expect(page).to have_link("#{order_2.id}")
      expect(page).to have_content("Date Created: #{order_2.created_at}")
      expect(page).to have_content("Total Quantity: #{order_2.total_quantity}")
      expect(page).to have_content("Grand Total: $#{order_2.grand_total}")
    end
  end
end
