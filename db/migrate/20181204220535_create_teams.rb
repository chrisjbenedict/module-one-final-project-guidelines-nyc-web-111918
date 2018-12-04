class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.integer :api_id
      t.string :name
      t.string :colors
      t.string :location
      t.string :founded
      t.string :venue
    end
  end
end
