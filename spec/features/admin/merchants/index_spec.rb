require 'rails_helper'

RSpec.describe 'As an admin user' do
  describe 'when I navigate to /merchants' do
    before :each do
      @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210, enabled?: false)
      @site_admin = User.create(name: 'Site Admin', address: '123 First', city: 'Denver', state: 'CO', zip: 80_233, email: 'site_admin@user.com', password: 'secure', role: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@site_admin)

      visit merchants_path
    end

    it 'I can see a link to create a new merchant' do
      expect(page).to have_link('New Merchant')

      click_on 'New Merchant'

      expect(current_path).to eq(new_merchant_path)
    end

    it 'it shows all merchants with their name, city, and state' do
      within "#merchant-#{@bike_shop.id}" do
        expect(page).to have_link(@bike_shop.name)
        expect(page).to have_content("#{@bike_shop.city}, #{@bike_shop.state}")
      end

      within "#merchant-#{@dog_shop.id}" do
        expect(page).to have_link(@dog_shop.name)
        expect(page).to have_content("#{@dog_shop.city}, #{@dog_shop.state}")
      end
    end

    it 'displays disable/enable links for merchants that are enabled/disabled' do
      within "#merchant-#{@bike_shop.id}" do
        click_link 'Disable'
      end

      @bike_shop.reload
      expect(current_path).to eq(merchants_path)
      expect(@bike_shop.enabled?).to eq(false)

      within "#merchant-#{@bike_shop.id}" do
        expect(page).to have_link('Enable')
      end

      within "#merchant-#{@dog_shop.id}" do
        click_link 'Enable'
      end

      @dog_shop.reload
      expect(current_path).to eq(merchants_path)
      expect(@dog_shop.enabled?).to eq(true)

      within "#merchant-#{@dog_shop.id}" do
        expect(page).to have_link('Disable')
      end
    end

    it 'displays a flash message when a merchant account is disabled' do
      within "#merchant-#{@bike_shop.id}" do
        click_link 'Disable'
      end

      expect(page).to have_content("#{@bike_shop.name} has been disabled!")
    end

    it 'displays a flash message when a merchant account is enabled' do
      within "#merchant-#{@dog_shop.id}" do
        click_link 'Enable'
      end

      expect(page).to have_content("#{@dog_shop.name} has been enabled!")
    end

    it 'disables all items for a merchant when the merchant has been disabled' do
      tire = @bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      pump = @bike_shop.items.create(name: 'Bike Pump', description: 'It works fast!', price: 25, image: 'https://images-na.ssl-images-amazon.com/images/I/71Wa47HMBmL._SY550_.jpg', active?: false, inventory: 15)

      pull_toy = @dog_shop.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)
      dog_bone = @dog_shop.items.create(name: 'Dog Bone', description: "They'll love it!", price: 21, image: 'https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg', active?: false, inventory: 21)

      within "#merchant-#{@bike_shop.id}" do
        click_link 'Disable'
      end

      tire.reload
      pump.reload
      pull_toy.reload
      dog_bone.reload

      expect(tire.active?).to eq(false)
      expect(pump.active?).to eq(false)
      expect(pull_toy.active?).to eq(true)
      expect(dog_bone.active?).to eq(false)
    end

    it 'enables all items for a merchant when the merchant has been enabled' do
      tire = @bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      pump = @bike_shop.items.create(name: 'Bike Pump', description: 'It works fast!', price: 25, image: 'https://images-na.ssl-images-amazon.com/images/I/71Wa47HMBmL._SY550_.jpg', active?: false, inventory: 15)

      pull_toy = @dog_shop.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)
      dog_bone = @dog_shop.items.create(name: 'Dog Bone', description: "They'll love it!", price: 21, image: 'https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg', active?: false, inventory: 21)

      within "#merchant-#{@dog_shop.id}" do
        click_link 'Enable'
      end

      tire.reload
      pump.reload
      pull_toy.reload
      dog_bone.reload

      expect(tire.active?).to eq(true)
      expect(pump.active?).to eq(false)
      expect(pull_toy.active?).to eq(true)
      expect(dog_bone.active?).to eq(true)
    end
  end
end
