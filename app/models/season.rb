class Season < ApplicationRecord
  has_many :teams, -> { order(:name) }, dependent: :destroy
  has_many :game_dates, -> { order(:date) }, dependent: :destroy
  has_many :games, -> { joins(:game_date).order("game_dates.date") }, dependent: :destroy
  has_many :players, -> { order(:name) }, as: :intervalable, dependent: :destroy
end
