class Game < ApplicationRecord
  include GameStats
  belongs_to :season
  belongs_to :game_date
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  has_many :periods, dependent: :destroy

  def date
    game_date.date
  end

  def url
    "%d%02d%02d0#{home_team.abbr}" % [date.year, date.month, date.day]
  end

  def quarters
    periods.where("quarter > 0")
  end

  [0, 1, 2, 3, 4].each do |quarter|
    define_method "players#{quarter}" do
      periods.find_by(quarter: quarter).players.includes(:stat)
    end
  end

  def quarter_players
    Player.where(intervalable_type: "Period", intervalable_id: quarters.ids)
  end
end
