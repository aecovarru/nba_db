module Database
  class GameStatBuilder < Builder
    ROW_INDICES = { sp: 1, fgm: 2, fga: 3, thpm: 5, thpa: 6, ftm: 8, fta: 9, orb: 11, drb: 12, ast: 14, stl: 15, blk: 16, tov: 17, pf: 18, pts: 19 }
    def run
      games.each { |game| build_stats(game) }
    end
    private
      def build_stats(game)
        puts "#{game.url} #{game.id}"
        period = Period.find_or_create_by(game: game, quarter: 0)
        doc = basketball_reference("/boxscores/#{game.url}.html")
        game.teams.each do |team|
          abbr = team.abbr.downcase
          data = doc.css("#box_#{abbr}_basic .right , #box_#{abbr}_basic .left").to_a
          rows = create_rows(data)
          stats = create_stats(team, period, rows)
        end
      end

      def create_stats(team, period, rows)
        rows = rows.each_with_index.map do |row, index|
          player_stats = player_attr(row[0]).merge(season: season, team: team)
          player = Player.find_by(player_stats)
          starter = index <= 6
          stat = Stat.find_or_create_by(intervalable: period, statable: player, starter: starter)
          next if row.size == 1
          stat_data = ROW_INDICES.map do |stat, index|
            text = row[index].text
            data = index == 1 && text.size != 0 ? parse_time(row[index]) : text.to_i
            [stat, data]
          end
          stat.update(Hash[stat_data])
        end
        return rows
      end

      def create_rows(data)
        rows = []
        row_num = 0
        row_size = data[20].text == "+/-" ? 21 : 20
        until data.empty?
          row_num += 1
          size = data[1].name == "td" || header?(data) ? row_size : 1
          row = data.shift(size)
          rows << row unless header?(row)
        end
        return rows
      end

      def header?(row)
        ["Starters", "Reserves", "Team Totals"].include?(row[0].text)
      end
  end
end