#encoding: utf-8
class MapRoutesController < ApplicationController
  include Geocoder
  def new
    @debug_origin = "Rua do Matão 1010, Cidade Universiatária, São Paulo"
    @debug_destination = "Avenida Paulista 1400, São Paulo"
    @json = {map_options: {zoom: 3, center_latitude: -40.235004, center_longitude: -51.92528}}
  end

  def create
    @route = MapRoute.create_from_locations(params[:origin_location],params[:destination_location])
    
    redirect_to @route
  end

  def show
    @route = MapRoute.find(params[:id])
    @json = MapRoute.find(params[:id]).route
  end
  
  def pois
    @json = Poi.all.to_gmaps4rails
  end
  
  def near_route
    @boxes = params["_json"]
    @markers = []
    @boxes.each do |box|  
      @markers += Poi.within_box(location: box)
    end
    respond_to do |format|
       format.json { render json: @markers.to_gmaps4rails }
    end
  end
end
