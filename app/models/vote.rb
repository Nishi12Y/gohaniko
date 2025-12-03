class Vote < ApplicationRecord
  belongs_to :shop
  belongs_to :group

  # 特定のユーザーがグループ内で投票済みかチェック
  def self.voted_in_group?(user_token:, group_id:)
    exists?(user_token: user_token, group_id: group_id)
  end
end
