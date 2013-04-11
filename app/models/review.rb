class Review
  include Mongoid::Document

field :user_name, :type => String
field :stars, :type => Integer
field :title, :type => String
field :text, :type => String
field :school, :type => String



end
