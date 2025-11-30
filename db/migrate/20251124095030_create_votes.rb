class CreateVotes < ActiveRecord::Migration[7.2]
  def change
    create_table :votes do |t|
      t.string :user_token, null: false, comment: "ユーザー識別用トークン"
      t.integer :score, null: false, comment: "投票スコア"

      t.references :shop, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end

    add_index :votes, [ :group_id, :user_token, :shop_id ], unique: true
    add_index :votes, [ :group_id, :shop_id ]
  end
end
