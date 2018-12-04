class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :name
      t.string :position
      t.integer :team_id
      t.string :team_name
      t.string :nationality
      t.integer :api_id
    end
  end
end
