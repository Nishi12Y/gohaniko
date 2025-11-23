class Shop < ApplicationRecord
  belongs_to :group

  enum status: {
    candidate: 0,  # 候補
    decided:   1   # 行き先決定
  }, _default: 0
end
