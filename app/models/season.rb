class Season < ApplicationRecord
  has_many :teams, -> { order(:name) }, dependent: :destroy
  has_many :game_dates, -> { order(:date) }, dependent: :destroy
  has_many :games, -> { includes(:game_date, :away_team, :home_team).order("game_dates.date") }, dependent: :destroy
  has_many :players, -> { order(:name) }, dependent: :destroy
  has_many :stats, as: :intervalable, dependent: :destroy
end
