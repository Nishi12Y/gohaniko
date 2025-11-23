class Group < ApplicationRecord
    validates :name, presence: true
    validates :outing_schedule, presence: true

    has_many :shops, dependent: :destroy

    # to_paramをオーバーライド
    def to_param
        uuid
    end
end
