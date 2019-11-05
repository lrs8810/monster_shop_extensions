class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.integer :nickname, default: 0

      t.timestamps
    end
  end
end
