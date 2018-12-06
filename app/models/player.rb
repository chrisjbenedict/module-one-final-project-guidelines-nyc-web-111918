class Player < ActiveRecord::Base
  has_many :scorecards
  has_many :matches, through: :scorecards

  belongs_to :team


  def self.most_common_nationalities
    nationalities_hash = Player.all.group_by{
      |player| player.nationality
    }
    count_hash={}
    nationalities_string = nationalities_hash.map do |nationality, players|
      # puts "Number of players from " + nationality + ": " + players.count.to_s
      count_hash[nationality]=players.count
    end
    count_hash.sort_by {|nationality, num| num}.reverse
  end

  def self.most_common_nationality
    self.most_common_nationalities.first
  end


end
