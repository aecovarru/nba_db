module Database
  class TeamBuilder
    def build(year)
      season = Season.find_by(year: year); names = get_names(year); countries = get_countries(year); abbrs = get_abbrs(year)
      (0...30).each do |index|
        team = Team.find_or_create_by(season: season, name: names[index], country: countries[index], abbr: abbrs[index])
      end
    end

    def get_names(year)
      tb = "Trail Blazers"
      %W[Hawks Celtics Nets Hornets Bulls Cavaliers Mavericks Nuggets Pistons Warriors Rockets Pacers Clippers Lakers Grizzlies Heat Bucks Timberwolves Pelicans Knicks Thunder Magic 76ers Suns #{tb} Kings Spurs Raptors Jazz Wizards]
    end

    def get_countries(year)
      gs = "Golden State"; la = "Los Angeles"; no = "New Orleans";
      ny = "New York"; okc = "Oklahoma City"; sa = "San Antonio"
      %W[Atlanta Boston Brooklyn Charlotte Chicago Cleveland Dallas Denver Detroit #{gs} Houston Indiana #{la} #{la} Memphis Miami Milwaukee Minnesota #{no} #{ny} #{okc} Orlando Philadelphia Phoenix Portland Sacramento #{sa} Toronto Utah Washington]
    end

    def get_abbrs(year)
      %w[ATL BOS BRK CHO CHI CLE DAL DEN DET GSW HOU IND LAC LAL MEM MIA MIL MIN NOP NYK OKC ORL PHI PHO POR SAC SAS TOR UTA WAS]
    end
  end
end