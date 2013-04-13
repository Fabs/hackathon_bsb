#encoding: utf-8
class School
  attr_accessor :local_best
  attr_accessor :local_quality
  include Gmaps4rails::ActsAsGmappable
  include Mongoid::Document
  
  # micro_censo fields
  field :pk_cod_entidade, type: Integer
  field :no_entidade, type: String
  index({ pk_cod_entidade: 1 }, {unique: true, name: 'pk_cod_entidade_index'})

  #
  # Begin resources
  #

  # Questionário escola (Prova Brasil)
  field :tx_resp_q037, type: String # computer
  field :tx_resp_q038, type: String # Internet :)
  field :tx_resp_q056, type: String # library
  field :tx_resp_q058, type: String # laboratory

  def has_computer?
    trueValues = ['A', 'B', 'C']
    trueValues.include?(self.tx_resp_q037)
  end

  def has_internet?
    trueValues = ['A', 'B', 'C']
    trueValues.include?(self.tx_resp_q038)
  end

  def has_library?
    trueValues = ['A', 'B', 'C']
    trueValues.include?(self.tx_resp_q056)
  end

  def has_laboratory?
    trueValues = ['A', 'B', 'C']
    trueValues.include?(self.tx_resp_q058)
  end

  #
  # End resources
  #

  #
  # Begin Prova Brasil
  #

  embeds_many :grades

  #
  # End Prova Brasil
  #

  #
  # Begin Geolocation
  #

  field :cep, type: String

  #
  #
  # End Geolocation
  #

  attr_accessor :local_best
  include Gmaps4rails::ActsAsGmappable
  include Mongoid::Geospatial

  acts_as_gmappable :position => :location

  field :gmaps, type: Boolean 
  field :location, type: Point
  field :address, type: String
  field :type, type: String  
  field :name, type: String
  
  field :rank, type: Float
  field :competence, type: Array
  field :enem, type: Float
  field :provabrasil, type: Float

  field :magic, type: Float  
  
  spatial_index :location
    
  def gmaps4rails_address
   "#{self.name}: #{self.rank}"
  end
  
  #Speed test for finding places
  def self.create_random
    puts School.destroy_all
    gen = Rubystats::NormalDistribution.new(5, 2)
    gen_enem = Rubystats::NormalDistribution.new(5, 2)
    2000.times do |p|
      lat = - (rand(23650000-23440000) + 23440000)/1000000.0
      lon = - (rand(46760000-46500000) + 46500000)/1000000.0
      loc = [lat,lon]
      school = School.new(gmaps: true, name: "School #{p}")
      school.magic = rand(64)
      school.location = loc
      school.rank = gen.rng.round(1)
      school.type = ["Publica","Privada"][p % 2]
      school.competence = [gen_enem.rng.round(2),gen_enem.rng.round(2),gen_enem.rng.round(2),gen_enem.rng.round(2),gen_enem.rng.round(2)]
      school.enem = gen_enem.rng.round(2)
      school.provabrasil = gen_enem.rng.round(2)
      school.save!
    end
  end
    
  #Marker Properties
  def gmaps4rails_infowindow
    "<a href='/escola/#{id}'>#{self.name}</a>: #{self.rank} #{self.local_best}"
  end
  
  def gmaps4rails_marker_picture
    rank = self.quality(0,0)
    score = self.provabrasil.round(0)
  
    color = ["ff5047","f9d230","7ef41e"][rank]
    marker =  {
     "picture" => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=#{score}|#{color}|000000",
     "width" => 21,
     "height" => 34,
    }
    return marker
  end
  
  def has_computer
    magic % 2 == 0
  end
    
  def has_internet
    magic % 4 == 0    
  end
  
  def has_library
    magic % 8 == 0
  end
  
  def has_laboratory
    magic % 16 == 0
  end
  
  
  def has_sport
    magic % 32 == 0  
  end
  
  def has_art
    magic % 64 == 0    
  end
  
  def self.filters
    ["has_computer","has_internet","has_library","has_laboratory","has_sport","has_art"]
  end
  
  def self.color_filters
    ["low_quality","normal","high_quality"]
  end

  def self.i18npt
    {
      "has_computer" => "Computador",
      "has_internet" => "Internet",
      "has_library" => "Biblioteca",
      "has_laboratory" => "Laboratório",
      "has_sport" => "Aulas de Esporte",
      "has_art" => "Aulas de Arte",
      "low_quality" => "Fraco",
      "normal" => "Médio",
      "high_quality" => "Forte",
    }
  end
  
  #Statistical Map
  def self.local_average(schools)
    schools.inject(0){|sum,s| sum + s.provabrasil} / schools.count.to_f
  end
  
  def self.local_deviation(schools)
    ex2 = schools.inject(0){|sum,s| sum + (s.provabrasil**2)} / schools.count.to_f    
    ex = School.local_average(schools)
    (ex2 - ex*ex)**0.5
  end
  
  def quality(average,deviation)
    if self.local_quality == nil
      if self.provabrasil < average - 0.53*deviation 
        self.local_quality =  0 
      elsif self.provabrasil > average + 0.53*deviation 
        self.local_quality =  2 
      else
        self.local_quality = 1
      end
    end
    return self.local_quality
  end
end
