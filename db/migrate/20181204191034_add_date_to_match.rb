class AddDateToMatch < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :match_date, :datetime
  end
end
