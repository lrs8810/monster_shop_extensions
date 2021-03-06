require 'rails_helper'

RSpec.describe 'As a registered user' do
  describe 'from my profile page' do
    before(:each) do
      @user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )
      @address = @user.addresses.create(address: '123 Main St', city: 'San Antonio', state: 'TX', zip: 78240)
      @address_2 = @user.addresses.create(address: '78 South St', city: 'Denver', state: 'TX', zip: 80218, nickname: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'I click on a link and am taken to a form to edit the address' do
      visit profile_path

      within "#address-#{@address.id}" do
        click_on 'Edit Address'
      end

      expect(current_path).to eq("/profile/#{@address.id}/edit")
    end

    it 'when clicking on the edit address link I can see my prepopulated data' do
      visit "/profile/#{@address.id}/edit"

      expect(find_field(:address).value).to eq(@address.address)
      expect(find_field(:city).value).to eq(@address.city)
      expect(find_field(:state).value).to eq(@address.state)
      expect(find_field(:zip).value).to eq(@address.zip)
    end

    it 'edited address data shows on the profile page' do
      visit "/profile/#{@address.id}/edit"

      fill_in :address, with: '124 South St'
      fill_in :city, with: 'Denver'
      fill_in :state, with: 'CO'
      fill_in :zip, with: '80218'

      click_button 'Update Address'

      expect(page).to have_content('Your address has been updated!')
      expect(page).to have_content("124 South St\nDenver, CO 80218")
    end

    it 'cannot update address without filling out all fields on the form' do
      visit "/profile/#{@address.id}/edit"

      fill_in :address, with: '124 South St'
      fill_in :city, with: ''
      fill_in :state, with: 'CO'
      fill_in :zip, with: '80218'

      click_button 'Update Address'

      expect(page).to have_content('City can\'t be blank')
    end

    it 'I cannot edit an address that has a shipped order' do
      order_1 = @user.orders.create(name: 'User 1', address_id: @address.id, status: 2)
      order_2 = @user.orders.create(name: 'User 1', address_id: @address_2.id, status: 1)

      visit profile_path

      within "#address-#{@address.id}" do
        expect(page).to_not have_link('Edit Address')
      end

      within "#address-#{@address_2.id}" do
        expect(page).to have_link('Edit Address')
      end
    end
  end
end
