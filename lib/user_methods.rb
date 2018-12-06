def get_team_by_player(player_name)
  found_player=Player.all.find_by(name: player_name)
  found_player.team.name
end

def find_matches_by_team_location(location)
  found_teams = Team.all.where(location: location)
  found_matches = Match.all.select do |match|
    found_teams.include?(match.hometeam) || found_teams.include?(match.awayteam)
  end
  found_matches.each do |match|
    match.match_object_formatted
  end
end

def find_matches_by_team_name(name)
  found_team = Team.all.where("name LIKE (?)", "%#{name}%")[0]
  found_matches = Match.all.select do |match|
    found_team.name == match.home_team_name || found_team.name == match.away_team_name
  end
  found_matches.each do |match|
    match.match_object_formatted
  end
  "All matches for #{name}."
end

def find_players_by_team_name(name)
  found_team = Team.all.where("name LIKE (?)", "%#{name}%")[0]
  found_players = Player.all.select do |player|
    player.team_name == found_team.name
  end
  found_players.each do |player|
    puts "#{player.name} | #{player.position}"
  end
end

# gets head-to-head match_up data given two teams and return their records against each other
def match_up_info(team1, team2)
  team1_wins = 0
  team2_wins = 0
  match_ties = 0
  found_team1 = Team.all.where("name LIKE (?)", "%#{team1}%")[0]#.select do |match|
  found_team2 = Team.all.where("name LIKE (?)", "%#{team2}%")[0]
  found_matches = Match.all.where(status: "FINISHED").select do |match|
    (match.home_team_name == found_team1.name && match.away_team_name == found_team2.name) ||
    (match.home_team_name == found_team2.name && match.away_team_name == found_team1.name)
  end
  found_matches.map do |match|
    if match.winner == found_team1
      team1_wins += 1
    elsif match.winner == found_team2
      team2_wins += 1
    else
      match_ties += 1
    end
  end
  puts "(#{found_team1.name}: #{team1_wins}, #{team2_wins}, #{match_ties})"
  puts "(#{found_team2.name}: #{team2_wins}, #{team1_wins}, #{match_ties})"
end

# returns all records for every team
def all_records_and_points
  sorted_team=Team.all.sort_by{|team|team.points}.reverse
  records_and_points_list = sorted_team.map do |team|
    record_and_points = "#{team.name}: #{team.record} | points: #{team.points}"
  end
  records_and_points_list.each do |record|
    puts record
  end
  puts " "
end

def find_player_by_nationality(nationality)
  players = Player.all.select do |player|
    player.nationality == nationality
  end
  players.each do |player|
    puts "#{player.name} - #{player.team_name}"
  end
end
