class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.belongs_to :season
      t.belongs_to :game_date
      t.references :away_team, references: :team
      t.references :home_team, references: :team
    end
  end
end
