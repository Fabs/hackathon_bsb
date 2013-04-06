class LandingController < ApplicationController
  def index
    @settings = {zoom: 7}
  end
end
