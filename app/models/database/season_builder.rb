module Database
  class SeasonBuilder < Builder
    def run
      Season.find_or_create_by(year: year)
    end
  end
end