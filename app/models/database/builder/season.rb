module Database
  class Builder
    class Season < Builder
      def build(year)
        Season.find_or_create_by(year: year)
      end
    end
  end
end