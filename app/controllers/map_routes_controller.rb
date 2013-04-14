#encoding: utf-8
class MapRoutesController < ApplicationController
  include Geocoder
  def new
    @json = {map_options: {zoom: 3, center_latitude: -40.235004, center_longitude: -51.92528}}
  end

  def create
    @errors = []
    locations = MapRoute.find_locations_for(params[:origin_location],params[:destination_location])
    @errors[0] = true if locations[0] == nil
    @errors[1] = true if locations[1] == nil
    
    if @errors.empty?
      @route = MapRoute.create_from_locations(locations)
      redirect_to @route
    else
      @origin = params[:origin_location]
      @destination = params[:destination_location]
      @json = {map_options: {zoom: 3, center_latitude: -40.235004, center_longitude: -51.92528}} 
      render :new
    end
  end

  def show
    @detour = valid_distance_for_param(params[:detour])    
    @route = MapRoute.find(params[:id])
    @json = MapRoute.find(params[:id]).route
  end
  
  def pois
    @json = School.all.to_gmaps4rails
  end
  
  def near_route
    @boxes = params["_json"]
    @markers = []
    
    @boxes.each do |box|  
      @markers += School.within_box(location: box)
    end
    @json = []

    dists = Statistics.get_distributions(@markers)
    @markers.each do |school|
      school.quality(dists)
    end
    
    @json[0] = @markers.to_gmaps4rails do |school, marker|
      marker.infowindow render_to_string(:partial => "/schools/infowindow", :locals => {school: school });
      marker.json({ filter_logic: {
        has_computer: school.has_computer?,
        has_internet: school.has_internet?,
        has_library: school.has_library?,
        has_laboratory: school.has_laboratory?,
        has_sport: school.has_sport?,
        has_art: school.has_art?,
        quality_category: school.quality(dists)} },
        );
    end
    
    @json[1] = 0
    
    # TODO: deleteme
    @json[2] = [0,0]
    
    respond_to do |format|
       format.json { render json:  @json}
    end
  end
  
  def best_school
    @school = School.find(params[:id])
    render layout: false
  end
  
  def valid_distance_for_param(detour)
    return 1 if detour == nil or detour.blank?

    detour_int = detour.to_i
    return 0.1 if detour_int < 0.1
    return 10 if detour_int > 10
    return detour_int
  end
end
