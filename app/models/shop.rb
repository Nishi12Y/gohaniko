class Shop < ApplicationRecord
  validates :name, presence: true
  validates :url, uniqueness: { scope: :group_id }, allow_blank: true

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
      .order(Arel.sql("COALESCE(SUM(votes.score), 0) DESC"))
  }

  before_validation :normalize_url
  before_save :set_coordinates, if: :should_geocode?
  # geocoded_by :name, latitude: :lat, longitude: :lon
  # before_save :geocode, if: :will_save_change_to_name?

  private

  # URLの正規化関数
  def normalize_url
    return if url.blank?
    self.url = url[%r{https?://[^\s]+}]
  end

  def should_geocode?
    puts("should_geocode? called")
    name.present? &&
      (will_save_change_to_name? || lat.blank? || lng.blank?)
  end

  def set_coordinates
    # ここでジオコーディングして latitude/longitude をセット
    puts("name: #{name}, address: #{address}")
    results = Geocoder.search(name) # ※できれば address 優先
    first = results&.first

    if first.nil? || first.coordinates.blank?
      Rails.logger.warn("[Shop geocode] no results address=#{address.inspect}")
      return
    end

    self.lat, self.lng = first.coordinates

  rescue => e
    Rails.logger.warn("[Shop geocode failed] address=#{address} #{e.class}: #{e.message}")
    # nil のまま保存を続行
    true
  end
end
