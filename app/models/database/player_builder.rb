module Database
  class PlayerBuilder < Builder
    ROW_SIZE = 8
    def run
      players = team_data.map do |data|
        Player.find_or_create_by(data)
      end
    end

    private
      def team_data
        teams.map do |team|
          rows = basketball_data("/teams/#{team.abbr}/#{year}.html", "#roster td").each_slice(ROW_SIZE)
          rows.map do |row|
            player_attr(row[0]).merge({season: season, team: team})
          end
        end.flatten(1)
      end
  end
end