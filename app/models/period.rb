class Period < ApplicationRecord
  has_many :stats, -> { includes(:statable) }, as: :intervalable, dependent: :destroy
  belongs_to :game
end
