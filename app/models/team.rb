class Team < ActiveRecord::Base
  has_many :players


  # returns matches for a given team
  def matches
    Match.all.select do |match|
      match.home_team_id == self.api_id || match.away_team_id == self.api_id
    end
  end

  def finishedmatches
    Match.all.select do |match|
      (match.home_team_id == self.api_id || match.away_team_id == self.api_id) && match.status=="FINISHED"
    end
  end

  def info
    puts "Team colors: #{self.colors}"
    puts "Team venue: #{self.venue}"
    puts "Founded: #{self.founded}"
    puts "Team Record: #{self.record}"
    puts ""
  end

  def record
    wins=self.finishedmatches.select{|match|match.winner==self}.count
    losses=self.finishedmatches.select{|match|match.winner!=self && match.winner!=nil}.count
    ties=self.finishedmatches.select{|match|match.winner==nil}.count
    "#{wins}-#{losses}-#{ties}"
  end

end
