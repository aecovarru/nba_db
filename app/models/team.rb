class Team < ApplicationRecord
  belongs_to :season
  has_many :players
  has_many :stats, as: :statable, dependent: :destroy
end
