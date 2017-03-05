module Database
  class Builder
    include BasketballReference
    def self.inherited(child_class)
      puts child_class
    end
  end
end