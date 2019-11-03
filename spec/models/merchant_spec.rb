# frozen_string_literal: true

require 'rails_helper'

describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should_not allow_value(nil).for(:enabled?) }
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :users }
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
    end
    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )
      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      @meg.items.create(name: 'Chain', description: "It'll never break!", price: 30, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      @meg.items.create(name: 'Chain', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      chain = @meg.items.create(name: 'Chain', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      user_1 = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )

      user_2 = User.create(
        name: 'Dan',
        address: '123 Main',
        city: 'Boulder',
        state: 'CO',
        zip: 80_303,
        email: 'Dan@email.com',
        password: 'secure',
        enabled?: false
      )
      order_1 = user_1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)
      order_2 = user_1.orders.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17_033)
      order_3 = user_1.orders.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17_033)
      order_4 = user_2.orders.create!(name: 'Dao', address: '123 Mike Ave', city: 'Boulder', state: 'CO', zip: 80_303)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_4.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities.sort).to eq(%w[Denver Hershey])
    end

    it 'specific_orders' do
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
      chain = @meg.items.create(name: 'Chain', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      tire = @meg.items.create(name: 'tire', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      bone = brian.items.create(name: 'bone', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )
      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)
      order_1.item_orders.create!(item: bone, price: bone.price, quantity: 5)
      order_1.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_1.item_orders.create!(item: tire, price: tire.price, quantity: 8)

      order_2 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)
      order_2.item_orders.create!(item: bone, price: bone.price, quantity: 3)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 7)
      order_2.item_orders.create!(item: tire, price: tire.price, quantity: 2)

      total_quantity = @meg.specific_orders.map(&:order_total_quantity)
      subtotal = @meg.specific_orders.map(&:order_total_cost)

      expect(total_quantity).to eq([10, 9])
      expect(subtotal).to eq([400.0, 360.0])
    end

    it 'five_most_popular' do
      chain = @meg.items.create(name: 'Chain', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      tire = @meg.items.create(name: 'Tire', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      helmet = @meg.items.create(name: 'Helmet', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      seat = @meg.items.create(name: 'Seat', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      pump = @meg.items.create(name: 'Pump', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      lock = @meg.items.create(name: 'Lock', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)

      user_1 = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )

      user_2 = User.create(
        name: 'Dan',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'Dan@email.com',
        password: 'secure',
        enabled?: false
      )

      order_1 = user_1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)
      
      order_1.item_orders.create!(item: pump, price: pump.price, quantity: 2)
      order_1.item_orders.create!(item: tire, price: tire.price, quantity: 8)
      order_1.item_orders.create!(item: helmet, price: helmet.price, quantity: 3)
      order_1.item_orders.create!(item: seat, price: seat.price, quantity: 5)
      order_1.item_orders.create!(item: chain, price: chain.price, quantity: 7)
      order_1.item_orders.create!(item: lock, price: lock.price, quantity: 10)
      
      order_2 = user_2.orders.create!(name: 'Mike', address: '123 Mike Ave', city: 'Chocolate', state: 'AL', zip: 14_044)

      order_2.item_orders.create!(item: pump, price: pump.price, quantity: 1000)
      order_2.item_orders.create!(item: tire, price: tire.price, quantity: 8)
      name = Item.five_most_popular_items.map(&:name)

      expect(name).to eq([lock.name, tire.name, chain.name, seat.name, helmet.name])
    end

    it 'five_least_popular' do
      chain = @meg.items.create(name: 'Chain', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      tire = @meg.items.create(name: 'Tire', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      helmet = @meg.items.create(name: 'Helmet', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      seat = @meg.items.create(name: 'Seat', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      pump = @meg.items.create(name: 'Pump', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      lock = @meg.items.create(name: 'Lock', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)

      user_1 = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )

      user_2 = User.create(
        name: 'Dan',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'Dan@email.com',
        password: 'secure',
        enabled?: false
      )

      order_1 = user_1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)

      order_1.item_orders.create!(item: pump, price: pump.price, quantity: 2)
      order_1.item_orders.create!(item: tire, price: tire.price, quantity: 8)
      order_1.item_orders.create!(item: helmet, price: helmet.price, quantity: 3)
      order_1.item_orders.create!(item: seat, price: seat.price, quantity: 5)
      order_1.item_orders.create!(item: chain, price: chain.price, quantity: 7)
      order_1.item_orders.create!(item: lock, price: lock.price, quantity: 10)

      order_2 = user_2.orders.create!(name: 'Mike', address: '123 Mike Ave', city: 'Chocolate', state: 'AL', zip: 14_044)

      order_2.item_orders.create!(item: pump, price: pump.price, quantity: 1000)
      order_2.item_orders.create!(item: tire, price: tire.price, quantity: 8)

      name = Item.five_least_popular_items.map(&:name)

      expect(name).to eq([pump.name, helmet.name, seat.name, chain.name, tire.name])
    end
  end
end
