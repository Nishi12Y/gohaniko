class RemoveNotNullFromGroupsOutingSchedule < ActiveRecord::Migration[7.2]
  def change
    change_column_null :groups, :outing_schedule, true
  end
end
