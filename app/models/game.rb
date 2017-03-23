class Game < ApplicationRecord
  include GameStats
  belongs_to :season
  belongs_to :game_date
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  has_many :periods, dependent: :destroy

  def teams
    return away_team, home_team
  end

  def url
    "%d%02d%02d0#{home_team.abbr}" % [date.year, date.month, date.day]
  end

  def full_game
    periods.find_by(quarter: 0)
  end

  def quarters
    periods.where("quarter > 0")
  end

  [0, 1, 2, 3, 4].each do |quarter|
    define_method "stats#{quarter}" do
      periods.find_by(quarter: quarter).stats.includes(:statable)
    end
  end

  def method_missing(name, *args, &block)
    game_date.send(name, *args, &block)
  end
end
