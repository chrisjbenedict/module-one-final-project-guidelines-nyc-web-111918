class DeleteGoalsScoredFromScorecards < ActiveRecord::Migration[5.2]
  def change
    remove_column :scorecards, :goals_scored
  end
end
