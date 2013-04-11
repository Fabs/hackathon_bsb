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
    return nil if s.empty?
    
    poi.location = [s[0].latitude,s[0].longitude]
    poi.save!
    poi
  end
  
  def gmaps4rails_address
   "#{self.name}"
  end
end
