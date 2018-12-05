class UpdateApiTeamIdColumnAndAddTeamIdColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :players, :team_id, :api_team_id
    add_column :players, :team_id, :integer
  end
end
