class Player < ApplicationRecord
  include PlayerStats
  has_many :stats, as: :statable, dependent: :destroy
  scope :by_minutes, -> { order("stats.sp DESC") }
  belongs_to :team

  def stat_hash
    stat.stat_hash
  end

  def opponent
    team.opponent
  end
end
