class Statistics

  def self.get_distributions(schools)
    dists = Hash.new
    [5, 9].each do |id_serie|
      grades = Grade.where(:id_serie => id_serie)
      dists[[id_serie]] = dist(grades)
    end

    dists[[5, 9]] = Statistics.dist(Grade.all)

    return dists
  end

  def self.dist(grades)
    average = Statistics.average(grades)
    deviation = Statistics.deviation(grades, average)
    return [average, deviation]
  end

  # TODO overflow caution when using more grades
  def self.average(grades)
    grades.inject(0) {|sum, g| sum + g.prova_brasil} / grades.count
  end

  def self.deviation(grades, average)
    e_x2 = grades.inject(0) {|sum, g| sum + (g.prova_brasil**2)} / grades.count
    (e_x2 - average*average)**0.5
  end
end
