class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name, index: true
      t.string :abbr, index: true
      t.string :abbr2
      t.string :country
    end
  end
end
