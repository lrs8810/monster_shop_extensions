# frozen_string_literal: true

Merchant.destroy_all
Item.destroy_all
Review.destroy_all
User.destroy_all
Order.destroy_all
ItemOrder.destroy_all

# merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)

# bike_shop items
tire = bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
pump = bike_shop.items.create(name: 'Bike Pump', description: 'It works fast!', price: 25, image: 'https://images-na.ssl-images-amazon.com/images/I/71Wa47HMBmL._SY550_.jpg', active?: false, inventory: 15)
helmet = bike_shop.items.create(name: 'Helmet', description: 'Protects your brain. Try it!', price: 15, image: 'https://www.rei.com/media/product/1289320004', inventory: 20)

# dog_shop items
pull_toy = dog_shop.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)
dog_bone = dog_shop.items.create(name: 'Dog Bone', description: "They'll love it!", price: 21, image: 'https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg', active?: false, inventory: 21)
dog_bowl = dog_shop.items.create(name: 'Dog Bowl', description: "Don't let your pupper die of thirst!", price: 30, image: 'https://img.chewy.com/is/image/catalog/54477_MAIN._AC_SL1500_V1547154540_.jpg', active?: false, inventory: 8)

# bike_shop reviews
tire.reviews.create(title: 'Sucks!', content: 'I really really hate it.', rating: 1)
tire.reviews.create(title: "It's okay.", content: 'Not that bad, I guess.', rating: 3)
tire.reviews.create(title: 'Amazing!', content: 'Truly changed my life!', rating: 5)

pump.reviews.create(title: 'Sucks!', content: 'I really really hate it.', rating: 1)
pump.reviews.create(title: "It's okay.", content: 'Not that bad, I guess.', rating: 3)
pump.reviews.create(title: 'Amazing!', content: 'Truly changed my life!', rating: 5)

helmet.reviews.create(title: 'Sucks!', content: 'I really really hate it.', rating: 1)
helmet.reviews.create(title: "It's okay.", content: 'Not that bad, I guess.', rating: 3)
helmet.reviews.create(title: 'Amazing!', content: 'Truly changed my life!', rating: 5)

# dog_shop reviews
pull_toy.reviews.create(title: 'Sucks!', content: 'I really really hate it.', rating: 1)
pull_toy.reviews.create(title: "It's okay.", content: 'Not that bad, I guess.', rating: 3)
pull_toy.reviews.create(title: 'Amazing!', content: 'Truly changed my life!', rating: 5)

dog_bone.reviews.create(title: 'Sucks!', content: 'I really really hate it.', rating: 1)
dog_bone.reviews.create(title: "It's okay.", content: 'Not that bad, I guess.', rating: 3)
dog_bone.reviews.create(title: 'Amazing!', content: 'Truly changed my life!', rating: 5)

dog_bowl.reviews.create(title: 'Sucks!', content: 'I really really hate it.', rating: 1)
dog_bowl.reviews.create(title: "It's okay.", content: 'Not that bad, I guess.', rating: 3)
dog_bowl.reviews.create(title: 'Amazing!', content: 'Truly changed my life!', rating: 5)

# regular user
user_1 = User.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, email: 'user_1@user.com', password: 'secure', role: 0)
user_2 = User.create(name: 'User 2', address: '987 First', city: 'Dallas', state: 'TX', zip: 75_001, email: 'user_2@user.com', password: 'secure', role: 0)

# merchant employee
bike_employee = bike_shop.users.create(name: 'Bike Employee', address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203, email: 'bike_employee@user.com', password: 'secure', role: 1)
dog_employee = dog_shop.users.create(name: 'Dog Employee', address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210, email: 'dog_employee@user.com', password: 'secure', role: 1)

# merchant admin
bike_admin = bike_shop.users.create(name: 'Bike Admin', address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203, email: 'bike_admin@user.com', password: 'secure', role: 2)
dog_admin = dog_shop.users.create(name: 'Dog Admin', address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210, email: 'dog_admin@user.com', password: 'secure', role: 2)

# site admin
site_admin = User.create(name: 'Site Admin', address: '123 First', city: 'Denver', state: 'CO', zip: 80_233, email: 'site_admin@user.com', password: 'secure', role: 3)

# orders
order_1 = user_1.orders.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233)
item_order_1a = order_1.item_orders.create(order_id: order_1.id, item_id: tire.id, quantity: 1, price: 100, merchant_id: bike_shop.id)
item_order_1b = order_1.item_orders.create(order_id: order_1.id, item_id: helmet.id, quantity: 1, price: 15, merchant_id: bike_shop.id)
item_order_1c = order_1.item_orders.create(order_id: order_1.id, item_id: pull_toy.id, quantity: 2, price: 10, merchant_id: dog_shop.id)

order_2 = user_2.orders.create(name: 'User 2', address: '987 First', city: 'Dallas', state: 'TX', zip: 75_001)
item_order_2a = order_2.item_orders.create(order_id: order_2.id, item_id: pull_toy.id, quantity: 1, price: 10, merchant_id: dog_shop.id)
item_order_2b = order_2.item_orders.create(order_id: order_2.id, item_id: tire.id, quantity: 2, price: 100, merchant_id: bike_shop.id)

order_3 = user_1.orders.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233)
item_order_3a = order_3.item_orders.create(order_id: order_3.id, item_id: helmet.id, quantity: 2, price: 15, merchant_id: bike_shop.id)

order_4 = user_2.orders.create(name: 'User 2', address: '987 First', city: 'Dallas', state: 'TX', zip: 75_001)
item_order_4a = order_4.item_orders.create(order_id: order_4.id, item_id: pull_toy.id, quantity: 2, price: 10, merchant_id: dog_shop.id)
