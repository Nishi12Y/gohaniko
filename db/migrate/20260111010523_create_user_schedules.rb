class CreateUserSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :user_schedules do |t|
      t.references :group_schedule_date, null: false, foreign_key: true
      t.references :schedule_participant, null: false, foreign_key: true
      t.integer :choice, null: false, comment: "0:×、1:△、2:○"

      t.timestamps
    end

    # 同じ参加者が同じ候補日に複数回答できないようにする
    add_index :user_schedules,
              [ :group_schedule_date_id, :schedule_participant_id ],
              unique: true,
              name: "index_user_schedules_on_date_and_participant"
  end
end
