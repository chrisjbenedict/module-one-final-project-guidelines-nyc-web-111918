class Match < ActiveRecord::Base
  has_many :scorecards
  has_many :players, through: :scorecards

  # returns the match with the highest total score as an array of Team 1: # v. Team 2: #
  def self.highest_scoring_match
    match_hash = Match.all.map do |match|
      total_score = match.home_team_score + match.away_team_score
      [match, total_score]
    end
    ordered = match_hash.sort_by{|match| match[1]}.reverse
    highest_scoring_match = ordered.first[0]
    "#{highest_scoring_match.home_team_name}: #{highest_scoring_match.home_team_score} v.  #{highest_scoring_match.away_team_name}: #{highest_scoring_match.away_team_score}"
  end

  # returns an array of the most common nationalities in the match in desc order
  def most_common_nationalities_list
    nationalities_hash = self.players.group_by{
      |player| player.nationality
    }
    count_hash={}
    nationalities_string = nationalities_hash.map do |nationality, players|
      # puts "Number of players from " + nationality + ": " + players.count.to_s
      count_hash[nationality]=players.count
    end
    count_hash.sort_by {|nationality, num| num}.reverse
  end

  # formats the most common nationalities array
  def print_most_common_nationalities
    self.most_common_nationalities_list.map do |nationality|
      if nationality[1] > 1
        puts "#{nationality[1]} players from #{nationality[0]}"
      else
        puts "#{nationality[1]} player from #{nationality[0]}"
      end
    end
    "These are the most common nationalities for #{self.home_team_name} v #{self.away_team_name}."
  end

  def self.find_future_matches
    Match.where(status: "SCHEDULED")
  end
  
end # end of Match class
