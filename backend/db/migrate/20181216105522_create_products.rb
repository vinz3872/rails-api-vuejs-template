class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :quantity, default: 1
      t.integer :price, default: 0

      t.timestamps
    end
  end
end
