class Period < ApplicationRecord
  has_many :players, -> { includes(:stat).order("stats.sp DESC") }, as: :intervalable, dependent: :destroy
  belongs_to :game
end
