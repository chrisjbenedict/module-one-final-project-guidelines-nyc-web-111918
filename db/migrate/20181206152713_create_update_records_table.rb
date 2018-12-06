class CreateUpdateRecordsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :update_records do |t|
      t.integer :match_day
      t.timestamps
      t.integer :number_of_match_updates
      t.boolean :saved_to_database
    end
  end
end


#Checks most recent completed game and gets match day

#Pulls matches for match_day+1

#Checks status of pulled matches

#If completed, update
