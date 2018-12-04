class CreateScorecards < ActiveRecord::Migration[5.2]
  def change
    create_table :scorecards do |t|
      t.integer :player_id
      t.integer :match_id
      t.integer :goals_scored
    end
  end
end
