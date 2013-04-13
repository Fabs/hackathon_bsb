function install_filters(){
  $("#school_data").append("Got Filter <br/>");
}

$(".filter_control").change(function (){
  filter = $(this).attr("filter_type");
  for (var i=0; i<Gmaps.map.markers.length; i++) {
    marker = Gmaps.map.markers[i];
    if (! marker.filter_logic[filter]){
      marker.serviceObject.setVisible(false);
    } else {
      marker.serviceObject.setVisible(true);
    }
  }
});