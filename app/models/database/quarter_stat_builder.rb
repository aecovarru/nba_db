module Database
  class QuarterStatBuilder
    include BasketballReference
    def build(year)
      season = Season.find_by_year(year)
      games = season.games
      games.each { |game| build_stats(game) }

    end

    def build_stats(game)
      puts "#{game.url} #{game.id}"
      @options = {game: game, players: game.players_0, player_stats: game.initialize_player_stats,
        quarter: 0, on_court: game.initial_on_court, possessions: 0}
      doc = basketball_reference("/boxscores/pbp/#{game.url}.html")
      if doc
        rows = doc.css("#pbp td").to_a
        build_stat(rows)
      end
    end

    def build_stat(rows)
      until rows.empty?
        row = rows.shift(size(rows))
        time = parse_time(row[0])
        add_stats(row[1], time)
        add_stats(row[5], time) unless row.size == 2
      end
    end

    def size(row)
      row[2].nil? || row[2].text.include?(":") ? 2 : 6
    end

    def add_stats(play, time)
      if valid_play?(play)
        player1, player2 = find_players(play)
        @options.merge!({play: play.text, player1: player1, player2: player2, time: time})
        PlayParser.new(@options).add_stats
      end
    end

    def find_players(play)
      player_idstrs = play.children.select { |child| child.class == Nokogiri::XML::Element }.map {|player| player.attributes["href"].value}
      player_idstrs.map! {|string| string[string.rindex("/")+1...string.index(".")]}
      return player_idstrs
    end

    def valid_play?(play)
      play.text.size > 1
    end

    def player_stats(game)
      player_stats = {}
      game.players.each { |player| player_stats[player] = stat_hash }
      return player_stats
    end
  end
end