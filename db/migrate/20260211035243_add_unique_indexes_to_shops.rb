class AddUniqueIndexesToShops < ActiveRecord::Migration[7.2]
  def change
    add_index :shops, [ :group_id, :url ],  unique: true
  end
end
