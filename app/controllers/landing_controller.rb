class LandingController < ApplicationController
  def index
    @json = {map_options: {zoom: 3, center_latitude: -40.235004, center_longitude: -51.92528}}
  end
end
