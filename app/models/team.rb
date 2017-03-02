class Team < ApplicationRecord
  has_many :players
  has_many :stats, as: :statable

  def game
    intervalable if intervalable_type == "Game"
  end

  def opponent
    game.teams.where.not(team: self).first if intervalable_type == "Game"
  end
end
