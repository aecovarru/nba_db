class TeamsController < ApplicationController
  def index
    @season = Season.find(params[:season_id])
    @teams = @season.teams
  end

  def show
    @season = Season.find(params[:season_id])
    @team = Team.find(params[:id])
    @players = @team.players
  end
end
