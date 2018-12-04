def connect(endpoint)
  api_key="ee3263e25720400b8457823cccb99510"

  current_page='https://api.football-data.org/v2/' + endpoint
  response = RestClient::Request.execute(
     :method => :get,
     :url => current_page,
     :headers => {'X-Auth-Token' => api_key}
  )
  response_hash = JSON.parse(response)

  response_hash

end

# loads a match hash given an api_match_id
def load_match_by_id(match_id)
  connect("matches/#{match_id}")
end

# loads a team hash given an api_team_id
def load_team_by_id(team_id)
  connect("teams/#{team_id}")
end

# loads a player hash given an api_player_id
def load_player_by_id(player_id)
  connect("players/#{player_id}")
end

# all matches finished and scheduled in CL (96 matches)
def save_match_from_hash(match)
  new_match = Match.find_or_create_by(api_match_id: match["id"])
  new_match.home_team_id = match["homeTeam"]["id"]
  new_match.home_team_name = match["homeTeam"]["name"]
  new_match.away_team_id = match["awayTeam"]["id"]
  new_match.away_team_name = match["awayTeam"]["name"]
  new_match.api_match_id = match["id"]
  new_match.duration = match["score"]["duration"]
  new_match.match_day = match["matchday"]
  match["score"]["fullTime"]["homeTeam"] ? new_match.home_team_score = match["score"]["fullTime"]["homeTeam"] : new_match.home_team_score = 0
  match["score"]["fullTime"]["awayTeam"] ? new_match.away_team_score = match["score"]["fullTime"]["awayTeam"] : new_match.away_team_score = 0
  new_match.match_date = match["utcDate"]
  new_match.status = match["status"]
  new_match.save
end

# find a team
def load_team(team_id)
  connect("teams/#{team_id}")
end

# find all teams in CL in 2018
def load_all_teams_in_CL
  connect("competitions/2001/teams")
end

# load all matches in CL, including Preliminary matches
def load_all_matches_in_CL
  connect("competitions/CL/matches")
end

# load all group and (theoretically) post-group matches once scheduled
def load_2018_group_stage_matches_in_CL
  cl_matches = load_all_matches_in_CL
  group_stage_matches=cl_matches["matches"].select { |match|
    match["group"] != "Preliminary Semi-finals" && match["group"] != "Preliminary Final" && match["group"] != nil
  }.sort_by { |match|
    match["utcDate"]
  }
  group_stage_matches.each do |match|
    save_match_from_hash(match)
  end
end

# find a squad of players if exists, else create full team of players
def save_all_players_by_team_id(team_id)
  data = load_team(team_id)
  data["squad"].map do |player|
    new_player = Player.find_or_create_by(api_id: player["id"])
    new_player.name = player["name"]
    new_player.position = player["position"] ? player["position"] : "Coach"
    new_player.team_id = team_id
    new_player.team_name = data["name"]
    new_player.nationality = player["nationality"]
    new_player.api_id = player["id"]
    new_player.save
  end
end

# creation of scorecards linking each player to his match
def create_scorecards_by_match(match)
  players = Player.where(team_id: match.home_team_id) + Player.where(team_id: match.away_team_id)
  players.map do |player|
    Scorecard.find_or_create_by(match_id: match.id, player_id: player.id)
  end
end

#
