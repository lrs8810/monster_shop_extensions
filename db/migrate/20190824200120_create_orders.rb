# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.integer :zip
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
