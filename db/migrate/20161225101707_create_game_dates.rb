class CreateGameDates < ActiveRecord::Migration[5.0]
  def change
    create_table :game_dates do |t|
      t.belongs_to :season
      t.datetime :date
    end
  end
end
