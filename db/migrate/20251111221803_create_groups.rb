class CreateGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :groups do |t|
      t.string :uuid, null: false
      t.string :name, null: false
      t.datetime :outing_schedule, null: false
      t.timestamps
    end

    add_index :groups, :uuid, unique: true
  end
end
