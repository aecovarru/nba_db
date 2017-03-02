class Stat < ApplicationRecord
  prepend PlayerStats
  belongs_to :statable, polymorphic: true
  belongs_to :invervalable, polymorphic: true

  def season
    statable if statable_type == "Season"
  end

  def team
    statable if statable_type == "Team"
    player.team if statable_type == "Player"
  end

  def player
    statable if statable_type == "Player"
  end

  def stat_hash
    Hash[self.attributes.map{|key, value| [key.to_sym, value]}.select{|key, value| ![:id, :statable_type, :statable_id].include?(key)}]
  end

  def mp
    minutes = sp/60
    seconds = "#{sp%60}".rjust(2, "0")
    "#{minutes}:#{seconds}"
  end

  def ortg
  end
end
