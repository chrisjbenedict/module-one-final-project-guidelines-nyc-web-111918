class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.integer :home_team_id
      t.integer :away_team_id
      t.string :home_team_name
      t.string :away_team_name
      t.integer :api_match_id
      t.string :duration
      t.integer :match_day
      t.integer :home_team_score
      t.integer :away_team_score
    end
  end
end
