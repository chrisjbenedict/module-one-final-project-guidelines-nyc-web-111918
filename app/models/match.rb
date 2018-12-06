class Match < ActiveRecord::Base
  has_many :scorecards
  has_many :players, through: :scorecards

  # returns the match with the highest total score as an array of Team 1: # v. Team 2: #
  def self.highest_scoring_matches
    match_hash = Match.all.map do |match|
      total_score = match.home_team_score + match.away_team_score
      [match, total_score]
    end
    ordered = match_hash.sort_by{|match| match[1]}.reverse
    highest_scoring_matches = ordered[0..4]
    highest_scoring_matches.each do |match_object|
      match_object[0].match_object_formatted
    end
    #{}"#{highest_scoring_match.home_team_name}: #{highest_scoring_match.home_team_score} v.  #{highest_scoring_match.away_team_name}: #{highest_scoring_match.away_team_score}"
  end

  def hometeam
    Team.find_by(api_id: self.home_team_id)
  end

  def awayteam
    Team.find_by(api_id: self.away_team_id)
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

  def match_object_formatted
    puts ""
    puts "#{self.match_date.in_time_zone('EST').strftime("%A %B %d, %Y at %I:%M %p")}"
    if self.status == "FINISHED"
      puts "#{self.home_team_name} (#{self.hometeam.record}): #{self.home_team_score} v. #{self.away_team_name} (#{self.awayteam.record}): #{self.away_team_score}"
    else
      puts "#{self.home_team_name} (#{self.hometeam.record}) v. #{self.away_team_name} (#{self.awayteam.record})"
    end
    puts " "
  end

  def self.find_future_matches
    future_matches = Match.where(status: "SCHEDULED")
    future_matches.map do |future_match|
      future_match.match_object_formatted
    end
    puts ""
    "The next game is #{future_matches.first.home_team_name} v #{future_matches.first.away_team_name} at #{future_matches.first.match_date}"
  end

  def self.find_finished_matches
    finished_matches = Match.where(status: "FINISHED")
    finished_matches.map do |finished_match|
      finished_match.match_object_formatted
    end
    puts ""
    "The last game played was #{finished_matches.first.home_team_name}: #{finished_matches.first.home_team_score} v #{finished_matches.first.away_team_name}: #{finished_matches.first.away_team_score} at #{finished_matches.first.match_date}"
  end

  def winner
    if self.home_team_score>self.away_team_score
      self.hometeam
    elsif self.home_team_score<self.away_team_score
      self.awayteam
    else
      nil
    end
  end


end # end of Match class
