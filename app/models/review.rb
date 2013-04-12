class Review
  Array.send :define_method, "dot", lambda {|b| self.zip(b).map{|x,y| x*y}.inject(0){|sum,n| sum + n }}
  
  include Mongoid::Document
  field :user_name, :type => String
  field :stars, :type => Integer
  field :title, :type => String
  field :text, :type => String
  field :school, :type => String

  def self.average_stars_on_partition(partition)
    partition.dot([1,2,3,4,5]) / partition.count.to_f
  end
  
  def self.partition_of(reviews)
    partition = [0,0,0,0,0]
    reviews.each do |r| 
      index = r.stars - 1
      partition[ index ] += 1
    end
    return partition
  end
end
