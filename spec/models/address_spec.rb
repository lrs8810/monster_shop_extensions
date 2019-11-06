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
end
