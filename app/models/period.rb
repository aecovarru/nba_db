class Period < ApplicationRecord
  has_many :stats, as: :intervalable, dependent: :destroy
  belongs_to :game
end