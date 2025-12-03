class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :group

  validates :user_token, presence: true
end
