class AddColumnToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :enabled?, :boolean, default: true
  end
end
