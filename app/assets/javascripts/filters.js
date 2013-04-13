function install_filters(){
}

$(".filter_control").change(function (){
  for (var i=0; i<Gmaps.map.markers.length; i++) {
    marker = Gmaps.map.markers[i];
    active = true;
    
    $(".filter_control").each(function() {
      filter = $(this).attr("filter_type");
      value = $(this).is(':checked');
      
      if(value == true){
        if (marker.filter_logic[filter] == false){
          active = false
        }
      } 
    });
    marker.serviceObject.setVisible(active);
  }
});

$(".filter_control_quality").change(function (){
  category = $(this).attr("filter_type");
  state = $(this).is(':checked');
  
  for (var i=0; i<Gmaps.map.markers.length; i++) {
    marker = Gmaps.map.markers[i];
    marker_category = marker.filter_logic["quality_category"].toString();
    if (marker_category == category){
      marker.serviceObject.setVisible(state);
    }
  }
});