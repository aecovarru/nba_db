module PlayerStats


  # might be wrong, checkr
  def fg_part
    fg_part = fgm * (1.0 - 0.5 * (pts - ftm)/(2.0 * fga)) * q_ast
    return fg_part
  end

  def ft_part
    (1 - (1 - ft_percent) ** 2) * 0.4 * self.fta
  end

  def ast_part
    0.5 * ((team_stat.pts - team_stat.ftm) - (self.pts - self.ftm)) / (2.0 * (team_stat.fga - self.fga)) * self.ast
  end

  def orb_part
    orb * team_stat.orb_weight * team_stat.play_percent
  end

  # Possessions

  def fgx_poss
    (fga - fgm) * (1.0 - 1.07 * team_stat.orb_percent)
  end

  def ftx_poss
    ((1.0 - ft_percent) ** 2) * 0.4 * fta
  end

  def sc_poss
    (fg_part + ast_part + ft_part) * (1 - (team_stat.orb / team_stat.sc_poss) * team_stat.orb_weight * team_stat.play_percent) + orb_part
  end

  def tot_poss
    sc_poss + fgx_poss + ftx_poss + tov
  end

  def plays
    fga + fta * 0.4 + tov
  end

  # Percentage

  # Percentage of a team_stat's possessions on which the team_stat scores at least 1 point
  def floor_percentage
    floor_percentage = sc_poss / tot_poss
    return floor_percentage
  end

  # Percentage of a team_stat's non-foul shot possessions on which the team_stat socres a field goal
  def field_percent
    field_percent = fgm / (fga - (orb/(orb + drb)) * (fga - fgm) * 1.07)
    return field_percent
  end

  # Percentage of a team_stat's "plays" on which the team_stat scores at least 1 point
  def play_percent
    play_percent = sc_poss / plays
    return play_percentage
  end

  def ft_percent
    ft_percent = ftm/fta
    return ft_percent
  end


  def poss_percent
    tot_poss / team_stat.tot_poss
  end

  def sc_poss_percent
    sc_poss / team_stat.sc_poss
  end

  # Points Produced

  def pprod_fg_part
    pprod_fg_part = 2 * (fgm + 0.5 * thpm) * (1 - 0.5 * ((pts - ftm) / (2 * fga)) * q_ast)
    return pprod_fg_part
  end

  def pprod_ast_part
    pprod_ast_part = 2 * ((team_stat.fgm - fgm + 0.5 * (team_stat.thpm - thpm)) / (team_stat.fgm - fgm)) * 0.5 * (((team_stat.pts - team_stat.ftm) - (pts - ftm)) / (2 * (team_stat.fga - fga))) * ast
    return pprod_ast_part
  end

  def pprod_orb_part
    pprod_orb_part = orb * team_stat.orb_weight * team_stat.play_percent * (team_stat.pts / (team_stat.fgm + (1 - (1 - (team_stat.ftm / team_stat.fta)) ** 2) * 0.4 * team_stat.fta))
    return pprod_orb_part
  end

  def pprod
    pprod = (pprod_fg_part + pprod_ast_part + ftm) * (1 - (team_stat.orb / team_stat.sc_poss) * team_stat.orb_weight * team_stat.play_percent) + pprod_orb_part
    return pprod
  end

  def ortg
    ortg = 100 * (pprod / tot_poss)
    return ortg
  end

  def predicted_points
    poss_percent * ortg
  end

  # Defense

  def dfg_percent
    var = opp_stat.fgm / opp_stat.fga
    return var
  end

  def dor_percent
    var = opp_stat.orb / (opp_stat.orb + team_stat.drb)
    return var
  end

  def fm_wt
    dfg = dfg_percent
    dor = dor_percent
    var = (dfg * (1 - dor)) / (dfg * (1 - dor) + (1 - dfg) * dor)
    return var
  end

  def stops_1
    fm_wt = fm_wt
    var = stl + blk * fm_wt * (1 - 1.07 * dor_percent) + drb * (1 - fm_wt)
    return var
  end

  def stops_2
    var = (((opp_stat.fga - opp_stat.fgm - team_stat.blk) / team_stat.mp) * fm_wt * (1 - 1.07 * dor_percent) + ((opp_stat.tov - team_stat.stl) / team_stat.mp)) * mp + (pf / team_stat.pf) * 0.4 * opp_stat.fta * (1 - (opp_stat.ftm / opp_stat.fta)) ** 2
    return var
  end

  def stops
    stops_1 + stops_2
  end

  def stop_percent
    var = (stops * opp_stat.mp) / (team_stat.tot_poss * mp)
    return var
  end

  def def_points_per_sc_poss
    var = opp_stat.pts / (opp_stat.fgm + (1 - (1 - (opp_stat.ftm / opp_stat.fta)) ** 2) * opp_stat.fta * 0.4)
    return var
  end

  def drtg
    team_stat.drtg + 0.2 * (100 * def_points_per_sc_poss * (1 - stop_percent) - team_stat.drtg)
  end
end
