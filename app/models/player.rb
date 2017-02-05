class Player < ApplicationRecord
  has_one :stat, as: :statable, dependent: :destroy
  belongs_to :team
  belongs_to :intervalable, polymorphic: true
  scope :by_minutes, -> { order("stats.sp DESC") }

  def stat_hash
    stat.stat_hash
  end
end
