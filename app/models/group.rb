class Group < ApplicationRecord
    validates :name, presence: true, length: { maximum: 24 }

    has_many :shops, dependent: :destroy
    has_many :votes, dependent: :destroy
    has_many :answers, dependent: :destroy
    has_many :group_schedule_dates, dependent: :destroy
    has_many :schedule_participants, dependent: :destroy

    # to_paramをオーバーライド
    def to_param
        uuid
    end
end
