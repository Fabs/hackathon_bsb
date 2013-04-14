#encoding: utf-8
class School
  attr_accessor :local_best
  attr_accessor :quality
  include Gmaps4rails::ActsAsGmappable
  include Mongoid::Document
  
  # micro_censo fields
  field :pk_cod_entidade, type: Integer
  field :no_entidade, type: String

  index({ pk_cod_entidade: 1 }, { unique: true })

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

  has_many :grades, autosave: true

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
  
  field :rank, type: Float
  field :competence, type: Array
  field :enem, type: Float
  field :provabrasil, type: Float

  field :magic, type: Float  
  
  spatial_index :location
    
  def gmaps4rails_address
   "#{self.name}: #{self.rank}"
  end
  
  def gmaps4rails_title
    "#{self.name}"
  end
  
  def self.create_random_provabrasil
    gen_pb = Rubystats::NormalDistribution.new(5, 2)
    School.all.each do |school|
      school.magic = rand(64)
      school.provabrasil = gen_pb.rng.round(2)
      school.save!
    end
  end
    
  #Marker Properties
  def gmaps4rails_infowindow
    "<a href='/escola/#{id}'>#{self.name}</a>: #{self.rank} #{self.local_best}"
  end
  
  def gmaps4rails_marker_picture
    rank = self.quality([]) # already in cache
    score = self.provabrasil.round(0)
  
    color = ["ff5047","f9d230","7ef41e"][rank]
    if rank == 0
      name = "low_quality_small"
    elsif rank == 1
      name = "normal_small"
    else
      name = "high_quality_small"
    end

    marker =  {
     "picture" => "/assets/#{name}.png",
     "width" => 21,
     "height" => 27,
    }
    return marker
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

  def prova_brasil
    if @grades.count == 1
      final_grade = @grades.first.prova_brasil
    elsif @grades.count > 1
      final_grade = self.calc_grades_average
    else # TODO: throw me
      final_grade = 5.42
    end
  end

  def calc_grades_average
    @grades.inject(0) {|sum, g| sum += g.prova_brasil} / @grades.count
  end
  
  def quality(dists)
    if @quality == nil
      @quality = calc_quality(dists)
    end

    return @quality
  end

  def calc_quality(dists)
    id_series = self.grades.collect{|g| g.id_serie}.sort
    dist = dists[id_series]
    (average, deviation) = dist

    if self.prova_brasil < average - 0.53*deviation
      quality = 0
    elsif self.prova_brasil > average + 0.53*deviation
      quality = 2
    else
      quality = 1
    end

    return quality
  end
  
  def name
    self.no_entidade
  end
end
