# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip
  
  validates_inclusion_of :enabled?, in: [true, false]

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.where(active?: true).count
  end

  def average_item_price
    items.where(active?: true).average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(order: :user)
      .where('"users"."enabled?" = \'t\'')
      .pluck('orders.city')
  end

  def specific_orders
    item_orders.group(:order_id)
      .select('item_orders.order_id, sum(quantity) as order_total_quantity,
        sum(quantity * item_orders.price) as order_total_cost'
      )
  end
end
