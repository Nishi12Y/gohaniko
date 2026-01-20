class UserSchedulesController < ApplicationController

  def new
    @group = Group.find_by(uuid: params[:group_uuid])
    @group_schedule_dates = @group.group_schedule_dates.order(:date)
  end

  def edit
    @group = Group.find_by(uuid: params[:group_uuid])
    @participant = ScheduleParticipant.find(params[:id])
    @group_schedule_dates = @group.group_schedule_dates.order(:date)
    @user_schedules = UserSchedule
      .where(schedule_participant_id: @participant.id)
      .index_by(&:group_schedule_date_id)
    
  end

  def create
    @group = Group.find_by(uuid: params[:group_uuid])
    ActiveRecord::Base.transaction do
      # ① schedule_participant 作成 or 取得
      participant = ScheduleParticipant.create!(
        group_id: @group.id,
        **schedule_participant_params
      )
      puts ("schedule_params:" + schedules_params.inspect)

      # ② user_schedules 用データを組み立て
      now = Time.current
      records = schedules_params.map do |schedule|
        {
          group_schedule_date_id: schedule[:group_schedule_date_id],
          schedule_participant_id: participant.id,
          choice: schedule[:choice],
          created_at: now,
          updated_at: now
        }
      end

      # ③ 複数日付を一括保存（重複は更新）
      UserSchedule.upsert_all(
        records,
        unique_by: :index_user_schedules_on_date_and_participant
      )
    end

    redirect_to group_group_schedule_dates_path(@group), notice: "出欠を登録しました"
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = "登録に失敗しました：#{e.record.errors.full_messages.join('、')}"
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
