class GroupScheduleDatesController < ApplicationController
  before_action :set_group

  def index
    @group_schedule_dates = @group.group_schedule_dates.order(:date)
    @participants = @group.schedule_participants.order(:created_at)

    # このグループの候補日に紐づく回答だけ取る（N+1回避でincludes）
    schedules = UserSchedule
      .joins(:group_schedule_date)
      .where(group_schedule_dates: { group_id: @group.id })
      .includes(:group_schedule_date, :schedule_participant)

    # (participant_id, date_id) => choice の検索用ハッシュ
    @choice_map = schedules.each_with_object({}) do |us, h|
      h[[ us.schedule_participant_id, us.group_schedule_date_id ]] = us.choice
    end

    @ok_counts_by_date = UserSchedule
    .joins(:group_schedule_date)
    .where(
      group_schedule_dates: { group_id: @group.id },
      choice: UserSchedule.choices[:ok]
    )
    .group(:group_schedule_date_id)
    .count
  end

  def create
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

  def destroy
    @group_schedule_date = @group.group_schedule_dates.find(params[:id])
    @group_schedule_date.destroy!
    redirect_to group_group_schedule_dates_path(@group), notice: "候補日を削除しました"
  rescue ActiveRecord::RecordNotFound
    redirect_to group_group_schedule_dates_path(@group), alert: "候補日が見つかりません"
  end

  private

  def group_schedule_dates_params
    params.require(:group_schedule_date).permit(candidate_dates: [])
  end
end
