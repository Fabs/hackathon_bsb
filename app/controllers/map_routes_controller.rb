class MapRoutesController < ApplicationController
  def new
    @json = {map_options: {zoom: 3, center_latitude: -40.235004, center_longitude: -51.92528}}
  end

  def create
  end

  def show
  end
end
