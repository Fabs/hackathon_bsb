class Poi
  include Gmaps4rails::ActsAsGmappable
  include Mongoid::Document
  
  acts_as_gmappable :position => :location
  
  field :gmaps, :type => Boolean
  field :location, :type => Array
  field :name, :type => String
  
  embedded_in :route, class_name: "MapRoute"
  
  def gmaps4rails_address
    #describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
   "#{self.name}, #{self.location}, #{self.route}"
  end
  
end
