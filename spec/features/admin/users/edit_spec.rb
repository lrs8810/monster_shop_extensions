require 'rails_helper'

RSpec.describe 'As an admin user' do
  describe 'when I visit a user\'s profile page' do
    before(:each) do
      @user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )

      @site_admin = User.create(
        name: 'Site Admin',
        email: 'site_admin@user.com',
        password: 'secure',
        role: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@site_admin)
    end

    it 'I can click on a link to edit that user\'s profile data' do
      visit "/admin/users/#{@user.id}"

      within '#user-info' do
        click_on 'Edit Profile'
      end

      expect(current_path).to eq("/admin/users/#{@user.id}/edit")
    end

    it 'is prepopulated with that user\'s previous data' do
      visit "/admin/users/#{@user.id}/edit"

      expect(find_field(:name).value).to eq(@user.name)
      expect(find_field(:email).value).to eq(@user.email)
    end

    it 'edited data shows on the profile page' do
      visit "/admin/users/#{@user.id}/edit"

      fill_in :name, with: 'Robert'
      fill_in :email, with: 'bob@email.com'

      click_button 'Update Profile'

      @user.reload

      expect(current_path).to eq("/admin/users/#{@user.id}")

      expect(page).to have_content("#{@user.name}'s profile data has been updated!")

      within '#user-info' do
        expect(page).to have_content('Robert')
        expect(page).to have_content('bob@email.com')
      end
    end

    it 'cannot be edited with an email already in use' do
      User.create(
        name: 'Bob',
        email: 'not_bob@email.com',
        password: 'secure'
      )

      visit "/admin/users/#{@user.id}/edit"

      fill_in :email, with: 'not_bob@email.com'

      click_button 'Update Profile'

      expect(page).to have_content('Email has already been taken')

      expect(find_field(:name).value).to eq(@user.name)
    end
  end
end
