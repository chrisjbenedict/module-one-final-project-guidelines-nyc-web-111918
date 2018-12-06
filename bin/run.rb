require 'pry'
require_relative '../config/environment'

system("clear")


puts "Champions League data was last updated at #{UpdateRecord.order(:created_at).last.created_at.in_time_zone('EST').strftime("%A %B %d, %Y at %I:%M %p")} for match day #{UpdateRecord.order(:created_at).last.match_day}"
puts " "
puts "Hey, mate! What would you like to know about the Champions League?"
puts "Some options include: (Please enter a number between 1-6)"
puts " "

#binding.pry

# def more_options
#   exitloop=false
#   while !exitloop
    # puts "1. Most Common Nationalities"
    # puts "2. Highest Scoring Matches"
    # puts "3. Games Played by Teams from a Given Country"
    # puts "4. Back"
    # puts "7. Exit"
    # user_input = gets.chomp.to_i
    # if user_input == 1
    #   Player.most_common_nationalities.each do |nationality|
    #     puts "#{nationality[0]}: #{nationality[1]}"
    #   end
    # elsif user_input == 2
    #   Match.highest_scoring_matches
    # elsif user_input == 3
    #   puts "What country would you like to search for?"
    #   location = gets.chomp
    #   find_matches_by_team_location(location)
    # elsif user_input == 4
    #
    # elsif user_input == 7
    #   exitloop=true
    # end
#   end
#   exitloop
# end
#
# def options
#   exitloop=false
#   while !exitloop
    # puts "1. Match Results"
    # puts "2. Upcoming Matches"
    # puts "3. Team Info"
    # puts "4. Your Team's Matches"
    # puts "5. Your Team's Squad"
    # puts "6. See More Options"
    # puts "7. Exit"
    # user_input = gets.chomp.to_i
    # if user_input == 1
    #   Match.find_finished_matches
    # elsif user_input == 2
    #   Match.find_future_matches
    # elsif user_input == 3
    #   puts "What's your team?"
    #   team = gets.chomp
    #   found_team=Team.find_by(name: team)
    #   if found_team
    #     found_team.info
    #   else
    #     puts "No team was found. Sorry, bud."
    #   end
    # elsif user_input == 4
    #   puts "What's your team?"
    #   team = gets.chomp
    #   find_matches_by_team_name(team)
    # elsif user_input == 5
    #   puts "What's your team?"
    #   team = gets.chomp
    #   find_players_by_team_name(team)
    # elsif user_input == 6
    #   exitloop=more_options
    # elsif user_input == 7
    #   exitloop=true
    # end
#
#     if (exitloop != true)
#       puts "Press enter to continue"
#       gets.chomp
#     end
#   end
# end


# options
exitloop=false
page=1

while !exitloop
  if page==1
    puts "1. All Match Results"
    puts "2. Upcoming Matches"
    puts "3. Team Info"
    puts "4. Team Matches"
    puts "5. Team Roster"
    puts "6. Update Data"
    puts "7. See More Options"
    puts "8. Exit"
    user_input = gets.chomp.to_i
    if user_input == 1
      Match.find_finished_matches
    elsif user_input == 2
      Match.find_future_matches
    elsif user_input == 3
      puts "Enter Team Name:"
      team = gets.chomp
      found_team=Team.where("name LIKE (?)", "%#{team}%")[0]
      if found_team
        found_team.info
      else
        puts "No team was found. Sorry, bud."
      end
    elsif user_input == 4
      puts "Enter Team Name:"
      team = gets.chomp
      find_matches_by_team_name(team)
    elsif user_input == 5
      puts "Enter Team Name:"
      team = gets.chomp
      find_players_by_team_name(team)
    elsif user_input == 6
      if update_matches
        puts "The matches have been updated."
      else
        puts "There is no new data to update."
      end
    elsif user_input == 7
      page=2
      system("clear")
    elsif user_input == 8
      exitloop=true
    end
  elsif page==2
    puts "1. Most Common Nationalities"
    puts "2. Highest Scoring Matches"
    puts "3. Find Games by Country"
    puts "4. Head to Head Match-ups"
    puts "5. Team Records and Points"
    puts "6. Find Players by Nationality"
    puts "7. Back"
    puts "8. Exit"
    user_input = gets.chomp.to_i
    if user_input == 1
      Player.most_common_nationalities.each do |nationality|
        puts "#{nationality[0]}: #{nationality[1]}"
      end
    elsif user_input == 2
      Match.highest_scoring_matches
    elsif user_input == 3
      puts "What country would you like to search for?"
      location = gets.chomp
      find_matches_by_team_location(location)
    elsif user_input == 4
      puts "Enter Team 1: "
      team1 = gets.chomp
      puts "Enter Team 2: "
      team2 = gets.chomp
      match_up_info(team1, team2)
    elsif user_input == 5
      all_records_and_points
    elsif user_input == 6
      puts "Enter a Name of a Country:"
      nationality = gets.chomp
      find_player_by_nationality(nationality)
    elsif user_input == 7
      page=1
      system("clear")
    elsif user_input == 8
      exitloop=true
    end
  else
    puts "This wasn't supposed to happen!"
  end
end
