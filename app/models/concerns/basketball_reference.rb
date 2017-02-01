module BasketballReference
  def basketball_reference(endpoint)
    begin
      url = File.join("http://www.basketball-reference.com","#{endpoint}")
      return Nokogiri::HTML(open(url, read_timeout: 10))
    rescue OpenURI::HTTPError => e
      puts "URL #{url} not found"
      return false
    rescue Net::OpenTimeout => e
      puts "URL #{url} timeout"
      return false
    end
  end

  def create_player(element, intervalable, team, starter=false)
    name, abbr = parse_name(element)
    idstr = parse_idstr(element)
    return Player.find_or_create_by(intervalable: intervalable, team: team, name: name, abbr: abbr, idstr: idstr, starter: starter)
  end

  def parse_name(element)
    last_name, first_name = element.attributes["csk"].value.split(",")
    return "#{first_name} #{last_name}", "#{first_name[0]}. #{last_name}"
  end

  def parse_idstr(element)
    return element.attributes["data-append-csv"].value
  end

  def parse_time(element)
    minutes, seconds = element.text.split(":").map(&:to_i)
    return minutes*60 + seconds
  end

  def stat_hash
    { sp: 0, fgm: 0, fga: 0 , thpa: 0, thpm: 0, fta: 0, ftm: 0, orb: 0, drb: 0, ast: 0, stl: 0, blk: 0, tov: 0, pf: 0, pts: 0, time: 0 }
  end
end