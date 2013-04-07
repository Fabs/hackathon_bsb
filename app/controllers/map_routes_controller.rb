class MapRoutesController < ApplicationController
  include Geocoder
  def new
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
end
