class Shop < ApplicationRecord
  belongs_to :group

  has_many :votes, dependent: :destroy

  enum status: {
    candidate: 0,  # 候補
    decided:   1   # 行き先決定
  }, _default: 0
end
