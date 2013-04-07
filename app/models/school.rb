class School
  include Gmaps4rails::ActsAsGmappable
  include Mongoid::Document
  include Mongoid::Geospatial
  
  acts_as_gmappable :position => :location
  
  field :gmaps, :type => Boolean
  field :location, type: Point
  field :name, :type => String
  field :rank, :type => Integer
  spatial_index :location
    
  def gmaps4rails_address
   "#{self.name} #{self.rank}"
  end
  
  #Speed test for finding places
  def self.create_random
    puts School.destroy_all
    gen = Rubystats::NormalDistribution.new(5, 2)
    2000.times do |p|
      lat = - (rand(23650000-23440000) + 23440000)/1000000.0
      lon = - (rand(46760000-46500000) + 46500000)/1000000.0
      loc = [lat,lon]
      school = School.new(gmaps: true, name: "School #{p}",rank: gen.rng)
      school.location = loc
      school.save!
      puts school.name
    end
  end
end
