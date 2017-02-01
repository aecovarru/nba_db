module Database
  class SeasonBuilder
    def build(year)
      Season.find_or_create_by(year: year)
    end
  end
end