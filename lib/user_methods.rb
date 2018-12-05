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
  found_team = Team.all.find_by(name: name)
  found_matches = Match.all.select do |match|
    found_team.name == match.home_team_name || found_team.name == match.away_team_name
  end
  found_matches.each do |match|
    match.match_object_formatted
  end
  "All matches for #{name}."
end
