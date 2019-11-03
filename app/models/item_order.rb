# frozen_string_literal: true

class ItemOrder < ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity, :status

  belongs_to :item
  belongs_to :order
  has_one :merchant, through: :item

  enum status: %w[Unfulfilled Fulfilled]

  def subtotal
    price * quantity
  end

  def reduce_inventory
    new_inventory = item.inventory - quantity
    item.update_attributes(inventory: new_inventory)
  end

  def return_inventory
    new_inventory = item.inventory + quantity
    item.update_attributes(inventory: new_inventory)
  end
end
