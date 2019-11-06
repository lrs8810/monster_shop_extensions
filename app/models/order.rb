# frozen_string_literal: true

class Order < ApplicationRecord
  validates_presence_of :name

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user
  belongs_to :address

  enum status: %w[Pending Packaged Shipped Cancelled]

  def grand_total
    item_orders.sum('price * quantity')
  end

  def total_quantity
    item_orders.sum(:quantity)
  end

  def find_order(merchant)
    item_orders.select('item_orders.*').where("merchant_id = #{merchant}")
  end

  def all_items_fulfilled?
    item_orders.where(status: 1).count == item_orders.count
  end

  def update_status(status)
    update_attributes(status: status)
  end

  def self.sort_orders
    order("
      case
        when status = 1 then 0
        when status = 0 then 1
        when status = 2 then 2
        when status = 3 then 3
      end
      ")
  end

  def packaged?
    status == 'Packaged'
  end
end
