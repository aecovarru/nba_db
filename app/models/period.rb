class Period < ApplicationRecord
  has_many :players, as: :intervalable, dependent: :destroy
  belongs_to :game
end
