class SchoolsController < ApplicationController
  def show
    @school = School.find(params[:id])

    @reviews = Review.where(:school => @school.id)

    @stars = 0.0
    @num_stars = [0, 0, 0, 0, 0]

    @num_reviews = 0
    @reviews.each do |r|
    	@stars += r.stars
    	@num_reviews += 1
    	@num_stars[r.stars] += 1
    end

    if @num_reviews != 0 
    	@stars /= @num_reviews
	end
  end

  def create_review
  	@new_user_name = params[:name]
  	@new_stars = params[:stars]
  	@new_title = params[:title]
  	@new_text = params[:text]
  	@new_school = params[:school]

  	r = Review.new
  	r.user_name = @new_user_name
  	r.stars = @new_stars
  	r.title = @new_title
  	r.text = @new_text
  	r.school = @new_school
  	r.save

  	redirect_to show_escola_path(@new_school)
  end

end
