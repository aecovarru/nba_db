class Period < ApplicationRecord
  has_many :stats, as: :intervalable
  belongs_to :game
end