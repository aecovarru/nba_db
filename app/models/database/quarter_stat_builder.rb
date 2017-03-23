module Database
  class QuarterStatBuilder < Builder
    def run
      games.each { |game| build_stats(game) }
    end

    def build_stats(game)
      puts "#{game.url} #{game.id}"
      full_game = game.periods.find_by(quarter: 0)
      stats = initialize_stats(full_game)
      on_court = Set.new
      @params = { game: game, stats: stats, quarter: 0, on_court: on_court, possessions: 0 }
      data = basketball_data("/boxscores/pbp/#{game.url}.html", "#pbp td").to_a
      build_stat(data)
    end

    def initialize_stats(full_game)
      player_id_hashes = full_game.stats.map(&:player).map do |player|
        { id: player.id, idstr: player.idstr }
      end
      return Hash[player_id_hashes.map do |id_hash|
        stat = Stat.new.stat_hash
        stat[:time] = 0
        stat[:starter] = false
        stat[:player_id] = id_hash[:id]
        [id_hash[:idstr], stat]
      end]
    end

    def build_stat(data)
      until data.empty?
        row = data.shift(size(data))
        time = parse_time(row[0])
        add_stats(row[1], time)
        add_stats(row[5], time) unless row.size == 2
      end
    end

    def size(data)
      data[2].nil? || data[2].text.include?(":") ? 2 : 6
    end

    def add_stats(play, time)
      if play.text.size > 1
        player1, player2 = find_player_idstrs(play)
        @params.merge!(play: play.text, player1: player1, player2: player2, time: time)
        PlayParser.new(@params).add_stats
      end
    end

    def find_player_idstrs(play)
      player_idstrs = play.children.select { |child| child.class == Nokogiri::XML::Element }.map {|player| player.attributes["href"].value}
      return player_idstrs.map {|string| string[string.rindex("/")+1...string.index(".")]}
    end

    # def player_stats(game)
    #   player_stats = {}
    #   game.players.each { |player| player_stats[player] = stat_hash }
    #   return player_stats
    # end
  end
end