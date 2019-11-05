require 'rails_helper'

RSpec.describe 'As a registered user' do
  describe 'from my profile page' do
    it 'I can delete an address' do
      user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )
      address_1 = user.addresses.create(address: '123', city: 'SA', state: 'TX', zip: 80_201)
      address_2 = user.addresses.create(address: '124 Main', city: 'SA', state: 'TX', zip: 78240, nickname: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path

      within "#address-#{address_1.id}" do
        click_on 'Delete Address'
      end

      user.reload

      expect(current_path).to eq(profile_path)
      # expect("address-#{address_1.id}").to_not be_present
      expect("address-#{address_2.id}").to be_present
      expect(user.addresses.count).to eq(1)
    end
  end
end
