class MapRoutesController < ApplicationController
  include Geocoder
  def new
    @json = {map_options: {zoom: 3, center_latitude: -40.235004, center_longitude: -51.92528}}
  end

  def create
    @route = MapRoute.new
    
    origin = params[:origin_name]
    @origin_poi = Poi.new(gmaps: true)
    @origin_poi.name = origin
    s = Geocoder.search(origin)
    @origin_poi.location = [s[0].latitude,s[0].longitude]
    @route.origin = @origin_poi
    
    destination = params[:destination_name]
    @destination_poi = Poi.new(gmaps: true)
    @destination_poi.name = destination
    s = Geocoder.search(destination)
    @destination_poi.location = [s[0].latitude,s[0].longitude]
    @route.destination = @destination_poi
    
    @origin_poi.save!
    @destination_poi.save!
    @route.save!
    redirect_to @route
  end

  def show
    @json = MapRoute.find(params[:id]).route
  end
end
