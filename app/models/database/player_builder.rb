module Database
  class PlayerBuilder
    include BasketballReference
    def build(year)
      @season = Season.find_by_year(year)
      @season.teams.each do |team|
        rows = basketball_reference("/teams/#{team.abbr}/#{year}.html").css("#roster td")
        rows.each_slice(8) do |row|
          create_player(row[0], @season, team)
        end
      end
    end
  end
end