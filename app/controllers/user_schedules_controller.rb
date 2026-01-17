class UserSchedulesController < ApplicationController

  def new
    @group = Group.find_by(uuid: params[:group_uuid])
    @group_schedule_dates = @group.group_schedule_dates.order(:date)
  end
end
