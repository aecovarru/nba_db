class Player < ApplicationRecord
  belongs_to :team
  belongs_to :season
  has_many :stats, as: :statable, dependent: :destroy
  scope :by_minutes, -> { order("stats.sp DESC") }
  include PlayerStats

  def stat_hash
    stat.stat_hash
  end

  def opponent
    team.opponent
  end
end
