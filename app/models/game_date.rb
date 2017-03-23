class GameDate < ApplicationRecord
  belongs_to :season
  has_many :games, dependent: :destroy
  def to_s
    date.strftime("%m/%d/%Y")
  end
end