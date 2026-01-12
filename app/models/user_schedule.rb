class UserSchedule < ApplicationRecord
  belongs_to :group_schedule_date
  belongs_to :schedule_participant

  enum choice: { ng: 0, maybe: 1, ok: 2 }

  validates :choice, presence: true

  validates :schedule_participant_id,
            uniqueness: { scope: :group_schedule_date_id },
            allow_blank: true
end
