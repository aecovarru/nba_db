class Team < ApplicationRecord
  belongs_to :season
  has_many :players
  has_one :stat, as: :statable

  def players
    season.players.where(team: self)
  end
end
