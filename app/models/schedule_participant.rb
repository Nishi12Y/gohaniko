class ScheduleParticipant < ApplicationRecord
  belongs_to :group

  has_many :user_schedules, dependent: :destroy
  has_many :group_schedule_dates, through: :user_schedules

  validates :name, presence: true
end
