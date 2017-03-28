module Stats
  class Ortg
    attr_reader :player, :team, :opp
    def initialize(player, team, opp)
      @player = player
      @team = team
      @opp = opp
    end
  end
  def q_5
    q_5 = 1.14 * ((team_stat.ast - ast) / team_stat.fgm)
  end
  def q_12
    q_12 = ((team_stat.ast / team_stat.mp) * mp * 5.0 - ast)/((team_stat.fgm / team_stat.mp) * mp * 5.0 - fgm)
    return q_12
  end
  def q_ast
    q_ast = mp / (team_stat.mp/5.0) * q_5 + (1.0 - mp/(team_stat.mp/5.0)) * q_12
    return q_ast
  end

end
