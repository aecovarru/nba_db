module Database
  class GameStatBuilder
    include BasketballReference
    def initialize
      @index_hash = { sp: 1, fgm: 2, fga: 3, thpm: 5, thpa: 6, ftm: 8, fta: 9, orb: 11, drb: 12, ast: 14,
        stl: 15, blk: 16, tov: 17, pf: 18, pts: 19 }
    end

    def build(year)
      @season = Season.find_by_year(year)
      games = @season.games
      games.each { |game| build_game(game) }
    end

    def build_game(game)
      puts "#{game.url} #{game.id}"
      doc = basketball_reference("/boxscores/#{game.url}.html")
      if doc
        [game.away_team, game.home_team].each do |team|
          abbr = team.abbr.downcase
          rows = doc.css("#box_#{abbr}_basic .right , #box_#{abbr}_basic .left").to_a
          @row_size = rows[20].text == "+/-" ? 21 : 20 
          period = Period.find_or_create_by(game: game, quarter: 0)
          create_player_stats(rows, period, team)
        end
      end
    end

    def create_player_stats(rows, period, team)
      row_num = 0
      until rows.empty?
        row_num += 1
        row = rows.shift(size(rows))
        next if header?(row)
        player = create_player(row[0], period, team, row_num <= 6)
        stat = Stat.find_or_create_by(statable: player)
        next if row.size == 1
        stat_array = @index_hash.map do |key, index|
          data = index == 1 ? parse_time(row[index]) : row[index].text.to_i
          [key, data]
        end
        stat.update(Hash[stat_array])
      end
    end

    def size(row)
      row[1].name == "td" || header?(row) ? @row_size : 1
    end

    def header?(row)
      ["Starters", "Reserves", "Team Totals"].include?(row[0].text)
    end
  end
end