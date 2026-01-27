class CreateScheduleParticipants < ActiveRecord::Migration[7.2]
  def change
    create_table :schedule_participants do |t|
      t.references :group, null: false, foreign_key: true
      t.string :name, null: false, comment: "ユーザー名"

      t.timestamps
    end

    add_index :schedule_participants, [ :group_id, :name ]
  end
end
