#encoding: utf-8
class MapRoutesController < ApplicationController
  include Geocoder
  def new
    @debug_origin = "Rua do Matão 1010, Cidade Universiatária, São Paulo"
    @debug_destination = "Parque do Ipiranga"
    @json = {map_options: {zoom: 3, center_latitude: -40.235004, center_longitude: -51.92528}}
  end

  def create
    @route = MapRoute.create_from_locations(params[:origin_location],params[:destination_location])
    
    redirect_to @route
  end

  def show
    School.create_random if School.count == 0 #debug, initialize schools if none
    @distance = valid_distance_for_param(params[:dist])    
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
    respond_to do |format|
       format.json { render json: @markers.to_gmaps4rails }
    end
  end
  
  def valid_distance_for_param(distance)
    distance_int = distance.to_i
    return 0.1 if distance_int < 0.1
    return 10 if distance_int > 10
    return distance_int
  end
end
