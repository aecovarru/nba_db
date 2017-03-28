class Period < ApplicationRecord
  has_many :stats, -> { includes(:statable) }, as: :intervalable, dependent: :destroy
  belongs_to :game
  def player_stats
    stats.where(statable_type: "Player")
  end

  def away_team_stat
    stats.find_by(statable: game.away_team)
  end

  def home_team_stat
    stats.find_by(statable: game.home_team)
  end

  def away_player_stats
    player_stats.select{|stat| stat.team == game.away_team}
  end

  def home_player_stats
    player_stats.select{|stat| stat.team == game.home_team}
  end
end
