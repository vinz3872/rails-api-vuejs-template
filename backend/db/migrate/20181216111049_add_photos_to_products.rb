class AddPhotosToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :photos, :json
  end
end
