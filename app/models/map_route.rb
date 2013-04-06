class MapRoute
  include Mongoid::Document
  embeds_one :origin, class_name: "Poi", inverse_of: :route
  embeds_one :destination, class_name: "Poi", inverse_of: :route  
end
