class Group < ApplicationRecord
    validates :name, presence: true
    validates :outing_schedule, presence: true
end
