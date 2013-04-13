function install_filters(){
}

$(".filter_control").change(function (){
  
  for (var i=0; i<Gmaps.map.markers.length; i++) {
    marker = Gmaps.map.markers[i];    
    marker.serviceObject.setVisible(false);
  }
  
  filter_value = ""
  $(".filter_control").each(function() {
    filter = $(this).attr("filter_type");
    value = $(this).is(':checked');
    filter_value += filter+":"+value+"<br/>"
    if(value){
      for (var i=0; i<Gmaps.map.markers.length; i++) {
        marker = Gmaps.map.markers[i];
        if (marker.filter_logic[filter]){
          marker.serviceObject.setVisible(true);
        }
      }  
    }
  });
  $("#school_data").html(filter_value);
});