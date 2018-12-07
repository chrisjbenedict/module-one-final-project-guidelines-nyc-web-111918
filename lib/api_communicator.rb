def connect(endpoint)
  api_key="ee3263e25720400b8457823cccb99510"

  current_page='https://api.football-data.org/v2/' + endpoint
  puts current_page
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

# find all teams in CL in 2018
def load_all_teams_in_CL
  connect("competitions/2001/teams")
end

# load all matches in CL, including Preliminary matches
def load_all_matches_in_CL
  connect("competitions/CL/matches")
end

def update_matches
  saved=nil
  match_check=Match.where(status: "FINISHED").order(:match_date).last
  match_day=match_check.match_day+1
  endpoint="competitions/2001/matches?matchday=#{match_day}"
  updated_matches=connect(endpoint)
  downloaded_match_status=updated_matches["matches"][0]["status"]
  if downloaded_match_status=="SCHEDULED"
    record=UpdateRecord.new(match_day: match_day, number_of_match_updates: 0, saved_to_database: false)
    record.save
    saved=false
  else
    record=UpdateRecord.new(match_day: match_day, number_of_match_updates: 0, saved_to_database: true)
    updated_matches["matches"].each do |match|
      record.number_of_match_updates+=1
      save_match_from_hash(match)
    end
    record.save
    saved=true
  end
  saved
end


# find a team
def load_team(team_id)
  connect("teams/#{team_id}")
end
