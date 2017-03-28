module Database
  class QuarterStatBuilder < Builder
    def run
      games.each { |game| build_stats(game) }
    end

    def build_stats(game)
      puts "#{game.url} #{game.id}"
      stats = initialize_stats(game)
      away_lineup = Set.new
      home_lineup = Set.new
      @params = { game: game, stats: stats, quarter: 0, away_lineup: away_lineup, home_lineup: home_lineup, possessions: 0 }
      data = basketball_data("/boxscores/pbp/#{game.url}.html", "#pbp td").to_a
      build_player_stats(data)
      build_team_stats(game)
    end

    def initialize_stats(game)
      full_game = game.full_game
      player_id_hashes = full_game.player_stats.map(&:player).map do |player|
        { id: player.id, idstr: player.idstr, team: player.team }
      end
      return Hash[player_id_hashes.map do |id_hash|
        stat = Stat.new.stat_hash
        stat[:time] = 0
        stat[:starter] = false
        stat[:player_id] = id_hash[:id]
        stat[:team] = id_hash[:team]
        [id_hash[:idstr], stat]
      end]
    end

    def build_player_stats(data)
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
    
    def build_team_stats(game)
      game.periods.each do |period|
        create_period_stats(game, period)
      end
    end

    def new_team_data(player_stats, team, period)
      team_data = Stat.new.stat_hash
      player_stats.each do |player_stat|
        player_data = player_stat.stat_hash
        player_data.each do |key, value|
          team_data[key] += value
        end
      end
      team_data[:statable] = team
      team_data[:intervalable] = period
      return team_data
    end

    def create_period_stats(game, period)
      away_team = game.away_team
      home_team = game.home_team
      player_stats = period.stats.where(statable_type: "Player")
      away_team_data = new_team_data(period.away_player_stats, away_team, period)
      home_team_data = new_team_data(period.home_player_stats, home_team, period)
      Stat.find_or_create_by(away_team_data)
      Stat.find_or_create_by(home_team_data)
    end
  end
end
