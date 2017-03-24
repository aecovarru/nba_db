module Database
  class Builder
    attr_reader :year, :season, :teams, :players, :game_dates, :games
    include BasketballReference
    def initialize(year)
      @year = year
      @season = Season.find_by_year(year)
      if @season
        @teams = @season.teams
        @players = @season.players
        @game_dates = @season.game_dates
        @games = @season.games
      end
    end

    def run
      [SeasonBuilder, TeamBuilder, GameBuilder, PlayerBuilder, GameStatBuilder, QuarterStatBuilder].each do |klass|
        builder = klass.new(year)
        builder.run
      end
    end
  end
end
