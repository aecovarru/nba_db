module GameStats
  def player_accuracy
    def fix_player_stat(idstr, quarter_stats)
      player_stat = self.players0.find_by_idstr(idstr).stat
      player_stat.update(quarter_stats[idstr])
    end
    game_stats = full_game_stats
    quarter_stats = summed_quarter_stats
    accuracy_record = {}
    players0.map {|player| player.idstr}.each do |idstr|
      accurate = game_stats[idstr] == quarter_stats[idstr]
      fix_player_stat(idstr, quarter_stats) unless accurate
      accuracy_record[idstr] = accurate
    end
    return accuracy_record
  end

  def accuracy
    summed_quarter_stats == full_game_stats
  end

  def summed_quarter_stats
    player_stats = initialize_player_stats
    quarters.each { |quarter| add_quarter_stats(player_stats, quarter) }
    return player_stats
  end

  def add_quarter_stats(player_stats, quarter)
    quarter.players.includes(:stat).each do |player|
      add_player_stats(player_stats[player.idstr], player.stat.stat_hash)
    end
  end

  def add_player_stats(player_stat, quarter_stat)
    quarter_stat.each { |key, value| player_stat[key] += value }
  end

  def initial_on_court
    self.players0.where(starter: true).map { |player| player.idstr }.to_set
  end

  def initialize_player_stats
    Hash[self.players0.map { |player| [player.idstr, Stat.new.stat_hash] }]
  end

  def full_game_stats
    Hash[self.players0.includes(:stat).map { |player| [player.idstr, player.stat.stat_hash] }]
  end
end