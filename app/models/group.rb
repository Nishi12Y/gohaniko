class Group < ApplicationRecord
    validates :name, presence: true
    validates :outing_schedule, presence: true

    # to_paramをオーバーライド
    def to_param
        uuid
    end

end
