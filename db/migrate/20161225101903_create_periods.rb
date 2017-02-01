class CreatePeriods < ActiveRecord::Migration[5.0]
  def change
    create_table :periods do |t|
      t.belongs_to :game
      t.integer :quarter
    end
  end
end
