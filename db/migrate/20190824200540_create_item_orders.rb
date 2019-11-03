# frozen_string_literal: true

class CreateItemOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :item_orders do |t|
      t.references :order, foreign_key: true
      t.references :item, foreign_key: true
      t.float :price
      t.integer :quantity
      t.integer :status, default: 0
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
