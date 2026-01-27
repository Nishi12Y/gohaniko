# app/forms/user_schedule_form.rb
class UserScheduleForm
  include ActiveModel::Model

  attr_accessor :group, :participant, :name, :schedules

  validates :group, presence: true
  validates :name, presence: true
  validate  :validate_all_dates_answered
  validate  :validate_choices_present

  def save!
    raise ActiveRecord::RecordInvalid, self unless valid?

    ActiveRecord::Base.transaction do
      p = participant || ScheduleParticipant.create!(group_id: group.id, name: name)
      p.update!(name: name)

      now = Time.current
      records = normalized_schedules.map do |s|
        {
          group_schedule_date_id: s[:group_schedule_date_id],
          schedule_participant_id: p.id,
          choice: s[:choice],
          created_at: now,
          updated_at: now
        }
      end

      UserSchedule.upsert_all(
        records,
        unique_by: :index_user_schedules_on_date_and_participant
      )

      @saved_participant = p
    end

    true
  end

  def saved_participant
    @saved_participant
  end

  # group_schedule_date_id => choice のHashを返す（復元用）
  def choice_by_date_id
    Array(schedules).each_with_object({}) do |s, h|
      hs = s.respond_to?(:to_h) ? s.to_h : s
      gid = hs[:group_schedule_date_id].to_i
      choice = hs[:choice]
      h[gid] = choice.nil? ? nil : choice.to_i
    end
  end

  private

  def normalized_schedules
    Array(schedules).map do |s|
      h = s.respond_to?(:to_h) ? s.to_h : s
      {
        group_schedule_date_id: h[:group_schedule_date_id].to_i,
        choice: h[:choice].nil? ? nil : h[:choice].to_i
      }
    end
  end

  def validate_all_dates_answered
    return if group.blank?

    expected_ids = group.group_schedule_dates.pluck(:id).sort
    received_ids = normalized_schedules.map { |s| s[:group_schedule_date_id] }.sort

    errors.add(:base, "全ての日程に回答してください") if expected_ids != received_ids
  end

  def validate_choices_present
    if normalized_schedules.any? { |s| s[:choice].nil? }
      errors.add(:base, "全ての日程に○/△/×を選択してください")
    end
  end
  
end