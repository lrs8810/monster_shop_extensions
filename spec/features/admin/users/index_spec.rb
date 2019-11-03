require 'rails_helper'

RSpec.describe 'As an admin user' do
  describe 'when I click the "Users" link in the nav' do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
      @user_1 = User.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, email: 'user.com', password: 'secure', role: 0)
      @dog_employee = @dog_shop.users.create(name: 'Dog Employee', address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210, email: 'dog_employee@user.com', password: 'secure', role: 1, enabled?: false)
      @dog_admin = @dog_shop.users.create(name: 'Dog Admin', address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210, email: 'dog_admin@user.com', password: 'secure', role: 2, enabled?: false)
      @site_admin = User.create(name: 'Site Admin', address: '123 First', city: 'Denver', state: 'CO', zip: 80_233, email: 'site_admin@user.com', password: 'secure', role: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@site_admin)

      visit admin_users_path
    end
    it 'it shows all users and their info' do

      within "#user-#{@user_1.id}" do
        expect(page).to have_link(@user_1.name)
        expect(page).to have_content("Date Registered: #{@user_1.created_at}")
        expect(page).to have_content("Role: #{@user_1.role}")
      end

      within "#user-#{@dog_employee.id}" do
        expect(page).to have_link(@dog_employee.name)
        expect(page).to have_content("Date Registered: #{@dog_employee.created_at}")
        expect(page).to have_content("Role: #{@dog_employee.role}")
      end

      within "#user-#{@dog_admin.id}" do
        expect(page).to have_link(@dog_admin.name)
        expect(page).to have_content("Date Registered: #{@dog_admin.created_at}")
        expect(page).to have_content("Role: #{@dog_admin.role}")
      end

      within "#user-#{@site_admin.id}" do
        expect(page).to have_link(@site_admin.name)
        expect(page).to have_content("Date Registered: #{@site_admin.created_at}")
        expect(page).to have_content("Role: #{@site_admin.role}")
      end
    end

    it 'can disable a user account' do
      within "#user-#{@user_1.id}" do
        click_link 'Disable'
      end

      expect(current_path).to eq(admin_users_path)

      expect(page).to have_content("#{@user_1.name} has been disabled!")

      @user_1.reload

      expect(@user_1.enabled?).to eq(false)

      within "#user-#{@user_1.id}" do
        expect(page).to have_link('Enable')
      end
    end

    it 'can enable a user account' do
      within "#user-#{@dog_employee.id}" do
        click_link 'Enable'
      end

      expect(current_path).to eq(admin_users_path)

      expect(page).to have_content("#{@dog_employee.name} has been enabled!")

      @dog_employee.reload

      expect(@dog_employee.enabled?).to eq(true)

      within "#user-#{@dog_employee.id}" do
        expect(page).to have_link('Disable')
      end
    end
  end
end
