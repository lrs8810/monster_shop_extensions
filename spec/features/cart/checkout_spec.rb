# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)

      @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      @paper = @mike.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
      @pencil = @mike.items.create(name: 'Yellow Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
      visit "/items/#{@paper.id}"
      click_on 'Add To Cart'
      visit "/items/#{@tire.id}"
      click_on 'Add To Cart'
      visit "/items/#{@pencil.id}"
      click_on 'Add To Cart'
      @items_in_cart = [@paper, @tire, @pencil]
    end

    it 'If I am a registered user, there is a link to checkout' do
      user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit cart_path

      expect(page).to have_link('Checkout')

      click_on 'Checkout'

      expect(current_path).to eq('/orders/new')
    end

    it 'If I am not a registerd user, there is no checkout link, but there is a prompt to register or login' do
      visit cart_path

      expect(page).to have_content('Please Register or Log In to Checkout')

      within '#checkout' do
        click_link 'Register'
      end

      expect(current_path).to eq(register_path)

      visit cart_path

      within '#checkout' do
        click_link 'Log In'
      end

      expect(current_path).to eq(login_path)
    end
  end

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit cart_path

      expect(page).to_not have_link('Checkout')
    end
  end
end
