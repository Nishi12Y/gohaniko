class GroupScheduleDatesController < ApplicationController

  def index
    @group = Group.find_by(uuid: params[:group_uuid])
    @group_schedule_dates = GroupScheduleDate.new
  end

  def create
    @group = Group.find_by(uuid: params[:group_uuid])

    dates = group_schedule_dates_params[:candidate_dates].reject(&:blank?)

    GroupScheduleDate.transaction do
      dates.each do |d|
        @group.group_schedule_dates.create!(date: d) 
      end
    end

    redirect_to group_group_schedule_dates_path(@group), notice: "候補日を登録しました"
  rescue ActiveRecord::RecordInvalid => e
      # ここに来た時点で transaction はロールバック済み
      flash.now[:alert] = "登録に失敗しました：#{e.record.errors.full_messages.join('、')}"
      render :new, status: :unprocessable_entity
  end

  private

  def group_schedule_dates_params
    params.require(:group_schedule_date).permit(candidate_dates: [])
  end
end
