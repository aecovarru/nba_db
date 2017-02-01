class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.belongs_to :season
      t.string :name, index: true
      t.string :country
      t.string :abbr, index: true
      t.string :abbr2
    end
  end
end
