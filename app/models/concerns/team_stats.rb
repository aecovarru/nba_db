module TeamStats
  def drtg(team=self, opponent=self.opponent)
    100 * (opponent.pts / team.tot_poss(team, opponent))
  end

  def ortg(team=self, opponent=self.opponent)
    100 * team.pts / team.tot_poss(team, opponent)
  end

  private
    def ft_percent(team=self, opponent=self.opponent)
      ftp = (team.ftm/team.fta).round(2)
      if ftp.nan?
        ftp = 0
      end
      return ftp
    end

    def sc_poss(team=self, opponent=self.opponent)
      (team.fgm + (1 - (1 - team.ft_percent(team, opponent)) ** 2 ) * team.fta * 0.4).round(2)
    end

    def tot_poss(team=self, opponent=self.opponent)
      0.5 * ((team.fga + 0.4 * team.fta - 1.07 * team.orb_percent(team, opponent) * (team.fga - team.fgm) + team.tov) + (opponent.fga + 0.4 * opponent.fta - 1.07 * opponent.orb_percent(opponent, team) * (opponent.fga - opponent.fgm) + opponent.tov))
    end

    def pace(team=self, opponent=self.opponent)
      48 * ((team.tot_poss(team, opponent) + opponent.tot_poss(opponent, team)) / (2 * (team.mp / 5)))
    end

    def plays
      (team.fga + team.fta * 0.4 + team.tov).round(2)
    end

    def orb_weight
      orb_p = team.orb_percent(team, opponent)
      play_p = team.play_percent(team, opponent)
      ((1.0 - orb_p) * play_p) / ((1.0 - orb_p) * play_p + orb_p * (1 - play_p))
    end

    def field_percent(team=self, opponent=self.opponent)
      (team.fgm / (team.fga - (team.orb / (team.orb + team.drb)) * (team.fga - team.fgm) * 1.07)).round(2)
    end

    def play_percent(team=self, opponent=self.opponent)
      (team.sc_poss(team, opponent)/team.plays(team, opponent)).round(2)
    end

    def orb_percent(team=self, opponent=self.opponent)
      team.orb / (team.orb + opponent.drb)
    end
end