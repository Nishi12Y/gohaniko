class AddDetailsToShops < ActiveRecord::Migration[7.2]
  def change
    add_column :shops, :lat, :float
    add_column :shops, :lng, :float
  end
end
