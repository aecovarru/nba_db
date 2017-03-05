module PlayerStats
  def q_5
    q_5 = 1.14 * ((team.ast - self.ast) / team.fgm)
  end

  def q_12
    q_12 = ((team.ast / team.mp) * self.mp * 5.0 - self.ast)/((team.fgm / team.mp) * self.mp * 5.0 - self.fgm)
    if q_12.nan? || q_12.to_s == 'Infinity' || q_12.to_s == '-Infinity'
      return 0.0
    end
    return q_12
  end

  def q_ast
    q_ast = self.mp / (team.mp/5.0) * self.q_5 + (1.0 - self.mp/(team.mp/5.0)) * self.q_12
    if q_ast.nan?
      return 0.0
    end
    return q_ast
  end

  # might be wrong, checkr
  def fg_part
    fg_part = self.fgm * (1.0 - 0.5 * (self.pts - self.ftm)/(2.0 * self.fga)) * self.q_ast
    if fg_part.nan?
      return 0.0
    end
    return fg_part
  end

  def ft_part
    (1 - (1 - self.ft_percent) ** 2) * 0.4 * self.fta
  end

  def ast_part
    0.5 * ((team.pts - team.ftm) - (self.pts - self.ftm)) / (2.0 * (team.fga - self.fga)) * self.ast
  end

  def orb_part
    self.orb * team.orb_weight * team.play_percent
  end

  # Possessions

  def fgx_poss
    (self.fga - self.fgm) * (1.0 - 1.07 * team.orb_percent)
  end

  def ftx_poss
    ((1.0 - self.ft_percent) ** 2) * 0.4 * self.fta
  end

  def sc_poss
    (self.fg_part + self.ast_part + self.ft_part) * (1 - (team.orb / team.sc_poss) * team.orb_weight * team.play_percent) + self.orb_part
  end

  def tot_poss
    self.sc_poss + self.fgx_poss + self.ftx_poss + self.tov
  end

  def plays
    self.fga + self.fta * 0.4 + self.tov
  end

  # Percentage

  # Percentage of a team's possessions on which the team scores at least 1 point
  def floor_percentage
    floor_percentage = self.sc_poss / self.tot_poss
    if floor_percentage.nan?
      return 0.0
    end
    return floor_percentage
  end

  # Percentage of a team's non-foul shot possessions on which the team socres a field goal
  def field_percent
    field_percent = self.fgm / (self.fga - (self.orb/(self.orb + self.drb)) * (self.fga - self.fgm) * 1.07)
    if field_percent.nan?
      return 0.0
    end
    return field_percent
  end

  # Percentage of a team's "plays" on which the team scores at least 1 point
  def play_percent
    play_percent = self.sc_poss / self.plays
    if play_percent.nan?
      return 0.0
    end
    return play_percentage
  end

  def ft_percent
    ft_percent = self.ftm/self.fta
    if ft_percent.nan?
      return 0.0
    end
    return ft_percent
  end


  def poss_percent
    self.tot_poss / team.tot_poss
  end

  def sc_poss_percent
    self.sc_poss / team.sc_poss
  end

  # Points Produced

  def pprod_fg_part
    pprod_fg_part = 2 * (self.fgm + 0.5 * self.thpm) * (1 - 0.5 * ((self.pts - self.ftm) / (2 * self.fga)) * self.q_ast)
    if pprod_fg_part.nan?
      pprod_fg_part = 0
    end
    return pprod_fg_part
  end

  def pprod_ast_part
    2 * ((team.fgm - fgm + 0.5 * (team.thpm - self.thpm)) / (team.fgm - self.fgm)) * 0.5 * (((team.pts - team.ftm) - (self.pts - self.ftm)) / (2 * (team.fga - self.fga))) * self.ast
  end

  def pprod_orb_part
    pprod_orb_part = self.orb * team.orb_weight * team.play_percent * (team.pts / (team.fgm + (1 - (1 - (team.ftm / team.fta)) ** 2) * 0.4 * team.fta))
    if pprod_orb_part.nan?
      pprod_orb_part = 0.0
    end
    return pprod_orb_part
  end

  def pprod
    pprod = (self.pprod_fg_part + self.pprod_ast_part + self.ftm) * (1 - (team.orb / team.sc_poss) * team.orb_weight * team.play_percent) + self.pprod_orb_part
    if pprod.nan?
      return 0.0
    end
    return pprod
  end

  def ortg
    ortg = 100 * (self.pprod / self.tot_poss)
    if ortg.nan?
      return 0.0
    end
    return ortg
  end

  def predicted_points
    self.poss_percent * self.ortg
  end

  # Defense

  def dfg_percent
    var = opponent.fgm / opponent.fga
    if var.nan?
      return 0.0
    end
    return var
  end

  def dor_percent
    var = opponent.orb / (opponent.orb + team.drb)
    if var.nan?
      return 0.0
    end
    return var
  end

  def fm_wt
    dfg = self.dfg_percent
    dor = self.dor_percent
    var = (dfg * (1 - dor)) / (dfg * (1 - dor) + (1 - dfg) * dor)
    if var.nan?
      return 0.0
    end
    return var
  end

  def stops_1
    fm_wt = self.fm_wt
    var = self.stl + self.blk * fm_wt * (1 - 1.07 * self.dor_percent) + self.drb * (1 - fm_wt)
    if var.nan?
      return 0.0
    end
    return var
  end

  def stops_2
    var = (((opponent.fga - opponent.fgm - team.blk) / team.mp) * self.fm_wt * (1 - 1.07 * self.dor_percent) + ((opponent.tov - team.stl) / team.mp)) * self.mp + (self.pf / team.pf) * 0.4 * opponent.fta * (1 - (opponent.ftm / opponent.fta)) ** 2
    if var.nan?
      return 0.0
    end
    return var
  end

  def stops
    self.stops_1 + self.stops_2
  end

  def stop_percent
    var = (self.stops * opponent.mp) / (team.tot_poss * self.mp)
    if var.nan?
      return 0.0
    end
    return var
  end

  def def_points_per_sc_poss
    var = opponent.pts / (opponent.fgm + (1 - (1 - (opponent.ftm / opponent.fta)) ** 2) * opponent.fta * 0.4)
    if var.nan?
      return 0.0
    end
    return var
  end

  def drtg
    team.drtg + 0.2 * (100 * self.def_points_per_sc_poss * (1 - self.stop_percent) - team.drtg)
  end
end