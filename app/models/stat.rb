class Stat < ApplicationRecord
  prepend PlayerStats
  belongs_to :statable, polymorphic: true
  belongs_to :intervalable, polymorphic: true

  def player
    statable if statable_type == "Player"
  end

  def team
    statable if statable_type == "Team"
  end

  def stat_hash
    Hash[self.attributes.map{|key, value| [key.to_sym, value]}.select{|key, value| ![:id, :statable_id, :statable_type, :intervalable_id, :intervalable_type].include?(key)}]
  end

  def mp
    minutes = sp/60
    seconds = "#{sp%60}".rjust(2, "0")
    "#{minutes}:#{seconds}"
  end

  def method_missing(name, *args, &block)
    intervalable.send(name, *args, &block)
  end
end
