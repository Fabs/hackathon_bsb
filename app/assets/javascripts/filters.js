function install_filters(){
}

$(".filter_control").change(function (){
  $("#school_data").html("");  
  for (var i=0; i<Gmaps.map.markers.length; i++) {
    marker = Gmaps.map.markers[i];
    marker.serviceObject.setVisible(true);
  }
  
  $(".filter_control").each(function() {
    filter = $(this).attr("filter_type");
    value = $(this).is(':checked');
    
    if(value == false){
      for (var i=0; i<Gmaps.map.markers.length; i++) {
        marker = Gmaps.map.markers[i];
        if (marker.filter_logic[filter] == false){
          marker.serviceObject.setVisible(false);
        }
      }      
    }
  });
  
});