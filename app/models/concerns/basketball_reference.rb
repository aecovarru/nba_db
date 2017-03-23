module BasketballReference
  def basketball_reference(path)
    url = File.join("http://www.basketball-reference.com", path)
    puts url
    return Nokogiri::HTML(open(url, read_timeout: 10))
  rescue OpenURI::HTTPError => e
    puts "URL #{url} not found"
    return false
  rescue Net::OpenTimeout => e
    puts "URL #{url} timeout"
    return false
  end

  def basketball_data(path, css)
    doc = basketball_reference(path)
    return doc.css(css) if doc
  end

  def player_attr(element)
    name, abbr = parse_name(element)
    idstr = parse_idstr(element)
    return {name: name, abbr: abbr, idstr: idstr}
  end

  def parse_name(element)
    last_name, first_name = element.attributes["csk"].value.split(",")
    return "#{first_name} #{last_name}", "#{first_name[0]}. #{last_name}"
  end

  def parse_idstr(element)
    return element.attributes["data-append-csv"].value
  end

  def parse_time(element)
    text = element.text
    minutes, seconds = text.split(":").map(&:to_i)
    return minutes*60 + seconds
  end

  def stat_hash
    { sp: 0, fgm: 0, fga: 0 , thpa: 0, thpm: 0, fta: 0, ftm: 0, orb: 0, drb: 0, ast: 0, stl: 0, blk: 0, tov: 0, pf: 0, pts: 0, time: 0 }
  end
end