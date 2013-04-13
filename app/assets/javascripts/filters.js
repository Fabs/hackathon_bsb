function install_filters(){
  for (var i=0; i<Gmaps.map.markers.length; i++) {
    Gmaps.map.markers[i].serviceObject.setVisible(false);
  }
}