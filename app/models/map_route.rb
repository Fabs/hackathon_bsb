class MapRoute
  include Mongoid::Document
  embeds_one :origin, class_name: "Poi", inverse_of: :route
  embeds_one :destination, class_name: "Poi", inverse_of: :route  
  
  def markers
    [self.origin,self.destination].to_gmaps4rails
  end
  
  def route
    {"from" => self.origin.name, "to" => self.destination.name}
  end
end
