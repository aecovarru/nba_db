class Season < ApplicationRecord
  has_many :teams, -> { order(:name) }
  has_many :game_dates, -> { order(:date) }
  has_many :games, -> { includes(:game_date, :away_team, :home_team).order("game_dates.date") }
  has_many :players, -> { order(:name) }
  has_many :stats, as: :intervalable
end
