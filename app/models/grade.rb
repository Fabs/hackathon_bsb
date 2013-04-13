#encoding: utf-8
class Grade
  include Mongoid::Document

  field :id_serie, type: Integer
  field :media_lp, type: Float
  field :media_mt, type: Float

  embedded_in :school
end
