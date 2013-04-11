class School
  include Gmaps4rails::ActsAsGmappable
  include Mongoid::Document
  include Mongoid::Geospatial
  
  acts_as_gmappable :position => :location
  
  field :gmaps, :type => Boolean
  field :location, type: Point
  field :name, :type => String
  field :rank, :type => Float
  spatial_index :location
    
  def gmaps4rails_address
   "#{self.name}: #{self.rank}"
  end
  
  #Speed test for finding places
  def self.create_random
    puts School.destroy_all
    gen = Rubystats::NormalDistribution.new(5, 2)
    2000.times do |p|
      lat = - (rand(23650000-23440000) + 23440000)/1000000.0
      lon = - (rand(46760000-46500000) + 46500000)/1000000.0
      loc = [lat,lon]
      school = School.new(gmaps: true, name: "School #{p}",rank: gen.rng.round(1))
      school.location = loc
      school.save!
      puts school.name
    end
  end
  
  #Marker Properties
  def gmaps4rails_infowindow
    "<a href='/escola/#{id}'>#{self.name}</a>: #{self.rank}"
  end
  
  def gmaps4rails_marker_picture
    rank = self.rank.round(0)
    color = ["ff5047","ff5746","fd8c40","fd903f","fbae38","f9d2230","f5f729","f5f729","b5f521","a1f520","8ef41f","7ef41e","7ef41e"][rank]
    {
     "picture" => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=#{rank}|#{color}|000000",
     "width" => 21,
     "height" => 34,
    }
  end
end
