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
    box2 = [[-23.582261432118372,-46.70228136437947],[-23.555281783940814,-46.692470000000014]]
    box3 = [[-23.582261432118372,-46.692470000000014],[-23.546288567881625,-46.63360181372349]]
    @markers = (Poi.within_box(location: box3) + Poi.within_box(location: box2)).to_gmaps4rails
  end
  
  def pois
    @json = Poi.all.to_gmaps4rails
  end
end
