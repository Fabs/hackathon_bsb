class SchoolsController < ApplicationController
  def show
    @school = School.find(params[:id])

    @reviews = Review.where(:school => @school.id)
    @partition = Review.partition_of(@reviews)
    @average = Review.average_stars_on_partition(@partition)
  end

  def create_review
    r = Review.new(params[:review])
  	r.save
    
    @new_school = School.find(r.school)

  	redirect_to show_escola_path(@new_school)
  end

end
