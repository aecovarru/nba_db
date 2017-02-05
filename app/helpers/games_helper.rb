module GamesHelper
  def game_link(game)
    link_to "#{game.away_team.name} vs #{game.home_team.name}", season_game_path(@season, game)
  end

  def date_header
    date = @game.game_date.date
    date.strftime("%Y/%m/%d")
  end
end