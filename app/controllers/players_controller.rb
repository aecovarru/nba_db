class PlayersController < ApplicationController
  def index
    @season = Season.find(params[:season_id])
    @team = Team.find(params[:team_id])
    @players = @team.players
  end

  def show
    @season = Season.find(params[:season_id])
    @team = Team.find(params[:team_id])
    @player = Player.find(params[:id])
  end
end
