module Database
  class Builder
    class Player < Builder
      def build(year)
        @season = Season.find_by_year(year)
        @season.teams.each do |team|
          doc = basketball_reference("/teams/#{team.abbr}/#{year}.html")
          if doc
            rows = doc.css("#roster td")
            rows.each_slice(8) do |row|
              create_player(row[0], @season, team)
            end
          end
        end
      end
    end
  end
end