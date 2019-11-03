# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory

  validates_inclusion_of :active?, in: [true, false]
  validates_inclusion_of :enabled?, in: [true, false]

  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, only_integer: true
  validates_numericality_of :inventory, greater_than: 0

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.five_most_popular_items
    find_by_sql("select items.name, sum(quantity) as purchase_amount from items 
      inner join item_orders on item_orders.item_id = items.id 
      inner join orders on orders.id = item_orders.order_id 
      inner join users on users.id = orders.user_id 
      where \"users\".\"enabled?\" = 't' 
      group by items.name 
      order by purchase_amount desc 
      limit 5;"
    )
  end

  def self.five_least_popular_items
    find_by_sql("select items.name, sum(quantity) as purchase_amount from items 
      inner join item_orders on item_orders.item_id = items.id 
      inner join orders on orders.id = item_orders.order_id 
      inner join users on users.id = orders.user_id 
      where \"users\".\"enabled?\" = 't' 
      group by items.name 
      order by purchase_amount
      limit 5;"
    )
  end
end
