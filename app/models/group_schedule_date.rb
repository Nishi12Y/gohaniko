class GroupScheduleDate < ApplicationRecord
  belongs_to :group
  has_many :user_schedules, dependent: :destroy
  has_many :schedule_participants, through: :user_schedules

  validates :date, presence: true
end
