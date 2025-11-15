class CreateShops < ActiveRecord::Migration[7.2]
  def change
    create_table :shops do |t|
      t.string  :name,    null: false, comment: "お店の名前"
      t.string  :address,             comment: "お店の住所"
      t.string  :url,                 comment: "お店のURL"
      t.integer :status, null: false, comment: "0:候補、1:行き先決定"

      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
