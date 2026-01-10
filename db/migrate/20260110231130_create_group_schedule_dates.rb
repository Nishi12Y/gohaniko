class CreateGroupScheduleDates < ActiveRecord::Migration[7.2]
  def change
    create_table :group_schedule_dates do |t|
      t.references :group, null: false, foreign_key: true
      t.date :date, null: false

      t.timestamps
    end

    # 同じグループで同じ日付を候補にできないようにする
    add_index :group_schedule_dates, [:group_id, :date], unique: true
  end
end
