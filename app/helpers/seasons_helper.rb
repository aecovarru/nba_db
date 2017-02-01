module SeasonsHelper
  def season_link(season)
    link_to "#{season.year} Season", season_path(season)
  end

  def season_games_link(season)
    link_to "#{season.year} Games", season_games_path(season)
  end

  def season_teams_link(season)
    link_to "#{season.year} Teams", season_teams_path(season)
  end

  def season_team_players_link(season, team)
    link_to "#{season.year} #{team.name} Players", season_team_players_path(season, team)
  end
end
