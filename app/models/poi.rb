class Poi
  include Gmaps4rails::ActsAsGmappable
  include Mongoid::Document
  include Mongoid::Geospatial
  
  acts_as_gmappable :position => :location
  
  field :gmaps, :type => Boolean
  field :location, type: Point
  field :name, :type => String
  field :route_id, :type => String
  spatial_index :location
  
  def self.create_from_location(location)
    poi = Poi.new(gmaps: true, name: location)
    s = Geocoder.search(location)
    poi.location = [s[0].latitude,s[0].longitude]
    poi.save!
    poi
  end
  
  def gmaps4rails_address
    #describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
   "#{self.name}, #{self.location}, #{self.route}"
  end
  
  #Speed test for finding places
  def self.create_random
    puts Poi.destroy_all
    2000.times do |p|
      lat = - (rand(23650000-23440000) + 23440000)/1000000.0
      lon = - (rand(46760000-46500000) + 46500000)/1000000.0
      loc = [lat,lon]
      poi = Poi.new(gmaps: true, name: "Poi #{p}")
      poi.location = loc
      poi.save!
      puts poi.name
    end
  end
end
