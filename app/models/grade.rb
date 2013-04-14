#encoding: utf-8
class Grade
  include Mongoid::Document

  field :id_serie, type: Integer
  field :media_lp, type: Float
  field :media_mt, type: Float

  index({ id_serie: 1, school_id: 1 }, { unique: true })

  belongs_to :school

  def media_lp_norm
    self.media_lp/350 * 10
  end

  def media_mt_norm
    self.media_mt/425 * 10
  end

  def prova_brasil
    (self.media_lp_norm + self.media_mt_norm) / 2
  end
end
