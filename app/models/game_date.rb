class GameDate < ApplicationRecord
  has_many :games, dependent: :destroy
  belongs_to :season

  def to_s
    date.strftime("%m/%d/%Y")
  end
end