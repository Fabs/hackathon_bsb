function install_filters(){
	blink_update("#total_markers",Gmaps.map.markers.length+"");
	blink_update("#current_markers",Gmaps.map.markers.length+"");  
}

function blink_update(item,value){
  $(item).fadeOut('slow', function(){
    $(item).html(value);
    $(this).fadeIn('slow');
  });
}

// function blink(item,current,target){
//   $(item).fadeOut(100,function(){
//     $(item).html(current - 1);
//     $(this).fadeIn(100,function(){
//       if ((current - 1) != target){
//         blink_update(item,current - 1, target)
//       }
//     });
//   });
// }

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