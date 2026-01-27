class UserSchedulesController < ApplicationController
  before_action :set_group

  def new
    @group = Group.find_by(uuid: params[:group_uuid])
    @group_schedule_dates = @group.group_schedule_dates.order(:date)

    @form = UserScheduleForm.new(
      group: @group,
      participant: nil,
      name: "",
      schedules: @group_schedule_dates.map { |d| { group_schedule_date_id: d.id, choice: nil } }
    )
  end

  def edit
    @group = Group.find_by(uuid: params[:group_uuid])
    @participant = ScheduleParticipant.find(params[:id])
    @group_schedule_dates = @group.group_schedule_dates.order(:date)

    existing = UserSchedule.where(schedule_participant_id: @participant.id)
                          .index_by(&:group_schedule_date_id)

    schedules = @group_schedule_dates.map do |d|
      { group_schedule_date_id: d.id, choice: existing[d.id]&.choice }
    end

    @form = UserScheduleForm.new(
      group: @group,
      participant: @participant,
      name: @participant.name,
      schedules: schedules
    )
  end

  def update
    @participant = ScheduleParticipant.find(params[:id])
    @group_schedule_dates = @group.group_schedule_dates.order(:date)
    @user_schedules = UserSchedule
      .where(schedule_participant_id: @participant.id)
      .index_by(&:group_schedule_date_id)

    @form = UserScheduleForm.new(
      group: @group,
      participant: @participant,
      name: schedule_participant_params[:name],
      schedules: schedules_params
    )

    @form.save!
    redirect_to group_group_schedule_dates_path(@group), notice: "出欠を更新しました"
  rescue ActiveRecord::RecordInvalid => e
    record = e.record
    flash.now[:alert] = "更新に失敗しました"
    render :edit, status: :unprocessable_entity
  end

  def create
    @group_schedule_dates = @group.group_schedule_dates.order(:date)

    @form = UserScheduleForm.new(
      group: @group,
      participant: nil,
      name: schedule_participant_params[:name],
      schedules: schedules_params
    )

    @form.save!
    redirect_to group_group_schedule_dates_path(@group), notice: "出欠を登録しました"
  rescue ActiveRecord::RecordInvalid => e
    # e.record が Form の場合もあるので両対応
    record = e.record
    flash.now[:alert] = "登録に失敗しました"
    render :new, status: :unprocessable_entity
  end

  private

  def schedule_participant_params
    params.require(:schedule_participant).permit(:name)
  end

  def schedules_params
    params.require(:schedules).values.map do |p|
      p.permit(:group_schedule_date_id, :choice)
    end
  end
end
