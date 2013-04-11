class MapRoute
  include Mongoid::Document
  embeds_one :origin, class_name: "Poi", inverse_of: :route
  embeds_one :destination, class_name: "Poi", inverse_of: :route  
  
  def self.find_locations_for(origin,destination)
    [Poi.create_from_location(origin),Poi.create_from_location(destination)]
  end
  
  def self.create_from_locations(pois)
    create(origin:pois[0], destination:pois[1])
  end
  
  def self.define_best_school(schools)
    schools[0].local_best = true
    return schools[0]
  end
  
  def markers
    [self.origin,self.destination].to_gmaps4rails
  end
  
  def route
    {"from" => self.origin.name, "to" => self.destination.name}
  end
end
