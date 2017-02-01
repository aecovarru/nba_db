class GamesController < ApplicationController
  def index
    @season = Season.find(params[:season_id])
    @games = @season.games.includes(:away_team, :home_team, :game_date)
  end

  def show
    @season = Season.find(params[:season_id])
    @game = Game.find(params[:id])
    @away_team = @game.away_team
    @home_team = @game.home_team
    @away_players = @game.players_0.where(team: @away_team)
    @home_players = @game.players_0.where(team: @home_team)
  end
end
