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
    puts "#{self.name}"
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

  def points
    wins = self.record.split('-')[0].to_i
    (wins * 3) + self.record.split('-')[2].to_i
  end

  def load_image
    load_team_by_id(self.api_id)["crestUrl"]
  end

  # def print_url
  #   url = load_image
  #   svg_str=open(url){|f| f.read }
  #
  #   def convert_svg_to_png(str)
  #     img, data = Magick::Image.from_blob(str) {
  #       self.format = 'SVG'
  #       self.background_color = 'transparent'
  #     }
  #     img.to_blob {
  #       self.format = 'PNG'
  #     }
  #   end
  #
  #   image_string = convert_svg_to_png(svg_str)
  #   img=Magick::Image.from_blob(image_string)[0]
  #
  #   img = img.change_geometry("25") {|cols, rows, img| img.resize!(cols, rows)}
  #
  #   img.each_pixel do |pixel, col, row|
  #     c = [pixel.red, pixel.green, pixel.blue].map { |v| 256 * (v / 65535.0) }
  #     pixel.opacity == 65535 ? print("  ") : print("  ".bg c)
  #     puts if col >= img.columns - 1
  #   end
  # end


end
