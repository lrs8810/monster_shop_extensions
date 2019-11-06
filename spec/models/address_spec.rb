# frozen_string_literal: true

require 'rails_helper'

describe Address, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_numericality_of(:zip) }
  end

  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many :orders }
  end

  describe 'nicknames' do
    it 'home address' do
      user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )
      home_address = user.addresses.create(address: '123 Main Street', state: 'Denver', city: 'CO', zip: 80_2018)

      expect(home_address.nickname).to eq('Home')
    end
  end

  describe 'instance methods' do
    it 'shipped_orders?' do
      @user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )
      @address_1 = @user.addresses.create(address: '123', city: 'SA', state: 'TX', zip: 80_201)
      @address_2 = @user.addresses.create(address: '124 Main', city: 'SA', state: 'TX', zip: 78240, nickname: 2)
      order_1 = @user.orders.create(name: 'User 1', address_id: @address_1.id, status: 2)
      order_2 = @user.orders.create(name: 'User 1', address_id: @address_1.id, status: 0)
      order_3 = @user.orders.create(name: 'User 1', address_id: @address_2.id, status: 1)

      expect(@address_1.orders.count).to eq(2)
      expect(@address_1.shipped_orders?).to eq(true)

      expect(@address_2.orders.count).to eq(1)
      expect(@address_2.shipped_orders?).to eq(false)
    end
  end
end
