class Shop < ApplicationRecord
  belongs_to :group

  has_many :votes, dependent: :destroy

  enum status: {
    candidate: 0,  # 候補
    decided:   1   # 行き先決定
  }, _default: 0

  # 投票の評価合計が高い順に並び替えるスコープ
  scope :ranked_by_votes, -> {
    left_joins(:votes)
      .group(:id)
      .order(Arel.sql('COALESCE(SUM(votes.score), 0) DESC'))
  }
end
