module PlayersHelper
  def players_link(player)
    link_to "#{player.name}", season_team_player_path(@season, @team, player)
  end
end
