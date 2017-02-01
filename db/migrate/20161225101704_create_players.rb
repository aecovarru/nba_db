class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.references :intervalable, polymorphic: true, index: true
      t.belongs_to :team
      t.string :name, index: true
      t.string :abbr, index: true
      t.string :idstr, index: true
      t.string :position
      t.boolean :starter
    end
  end
end
