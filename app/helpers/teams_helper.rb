module TeamsHelper
  def team_link(team)
    link_to "#{team.name}", season_team_path(@season, team)
  end
end