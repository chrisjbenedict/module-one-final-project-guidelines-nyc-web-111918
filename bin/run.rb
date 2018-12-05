require 'pry'
require_relative '../config/environment'




puts "Hey, mate! What would you like to know about the Champions League?"
puts "Some options include: (Please enter a number between 1-6)"

# binding.pry

def more_options
  exitloop=false
  while !exitloop
    puts "1. Most Common Nationalities"
    puts "2. Highest Scoring Matches"
    puts "3. Set a Match Calendar Reminder"
    puts "4. Back"
    puts "7. Exit"
    user_input = gets.chomp.to_i
    if user_input == 1
      Player.most_common_nationalities.each do |nationality|
        puts "#{nationality[0]}: #{nationality[1]}"
      end
    elsif user_input == 2
      Match.highest_scoring_matches
    elsif user_input == 3
    elsif user_input == 4
    elsif user_input == 7
      exitloop=true
    end
  end
  exitloop
end

def options
  exitloop=false
  while !exitloop
    puts "1. Match Results"
    puts "2. Upcoming Matches"
    puts "3. Team Info"
    puts "4. Your Team's Matches"
    puts "5. Games Played By Teams from a Given Country"
    puts "6. See More Options"
    puts "7. Exit"
    user_input = gets.chomp.to_i
    if user_input == 1
      Match.find_finished_matches
    elsif user_input == 2
      Match.find_future_matches
    elsif user_input == 3
      puts "What's your team?"
      team = gets.chomp
      found_team=Team.find_by(name: team)
      if found_team
        found_team.info
      else
        puts "No team was found. Sorry, bud."
      end
    elsif user_input == 4
      puts "What's your team?"
      team = gets.chomp
      find_matches_by_team_name(team)
    elsif user_input == 5
      puts "What country would you like to search for?"
      location = gets.chomp
      find_matches_by_team_location(location)
    elsif user_input == 6
      exitloop=more_options
    elsif user_input == 7
      exitloop=true
    end

    if (exitloop != true)
      puts "Press enter to continue"
      gets.chomp
    end
  end
end


options
