module Database
  class QuarterStat < Builder
    def run
      games.each { |game| build_stats(game) }
    end

    def build_stats(game)
      puts "#{game.url} #{game.id}"
      @options = {game: game, players: game.players0, player_stats: game.initialize_player_stats,
        quarter: 0, on_court: game.initial_on_court, possessions: 0}
      data = basketball_data("/boxscores/pbp/#{game.url}.html", "#pbp td").to_a
      build_stat(data)
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
        @options.merge!({play: play.text, player1: player1, player2: player2, time: time})
        PlayParser.new(@options).add_stats
      end
    end

    def find_player_idstrs(play)
      player_idstrs = play.children.select { |child| child.class == Nokogiri::XML::Element }.map {|player| player.attributes["href"].value}
      player_idstrs.map! {|string| string[string.rindex("/")+1...string.index(".")]}
      return player_idstrs
    end

    def player_stats(game)
      player_stats = {}
      game.players.each { |player| player_stats[player] = stat_hash }
      return player_stats
    end
  end
end