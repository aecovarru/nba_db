class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.references :season, index: true
      t.string :name, index: true
      t.string :abbr, index: true
      t.string :abbr2
      t.string :country
    end
  end
end
