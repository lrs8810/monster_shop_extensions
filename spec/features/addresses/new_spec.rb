require 'rails_helper'

RSpec.describe 'As a registered user' do
  describe 'from the profile page' do
    it 'I can create a new address' do
      user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )
      user.addresses.create(address: '123', city: 'SA', state: 'TX', zip: 80_201)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path

      click_on 'New Address'

      expect(current_path).to eq('/profile/new_address')

      fill_in :address, with: '78 South St'
      fill_in :city, with: 'San Antonio'
      fill_in :state, with: 'TX'
      fill_in :zip, with: '78240'

      click_button 'Add Address'

      user.reload

      expect(current_path).to eq(profile_path)

      expect(page).to have_content('Your address has been added!')

      within '#addresses' do
        expect(page).to have_content("123\nSA, TX 80201")
        # expect(page).to have_content("78 South St\nSan Antonio, TX 78240")
      end
    end
  end
end
