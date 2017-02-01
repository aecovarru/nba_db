class Stat < ApplicationRecord
  belongs_to :statable, polymorphic: true
  def stat_hash
    def valid_stat(key)
      ![:id, :statable_type, :statable_id].include?(key)
    end
    Hash[self.attributes.map{ |key, value| [key.to_sym, value] }.select{|key, value| valid_stat(key)}]
  end

  def mp
    return (sp.to_f/60).round(2)
  end
end
