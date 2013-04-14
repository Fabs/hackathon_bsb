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

function show_filters_panel(){
  $('.hidden_filters').fadeIn(1000)
}


function update_filters(){
  visibles = 0;
  for (var i=0; i<Gmaps.map.markers.length; i++) {
    marker = Gmaps.map.markers[i];
    
    if (marker.serviceObject.getVisible()){
      visibles += 1
    }
  }
  blink_update("#current_markers",visibles);
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
    active = check_mandatory_filters(marker,active)
    marker.serviceObject.setVisible(active);
  }
  update_filters()
});

$(".filter_control_quality").change(function (){
  apply_mandatory_filter(this);
  update_filters();
});

function check_mandatory_filters(marker,active){
  after_check_state = active;
  $(".filter_control_quality").each(function(){
    category = $(this).attr("filter_type");
    state = $(this).is(':checked');
    
    if (state == false){
      marker_category = marker.filter_logic["quality_category"].toString();
      if (marker_category == category ){
        after_check_state = false;
      }
    }
  });
  return after_check_state;
}

function apply_mandatory_filter(filter){
  category = $(filter).attr("filter_type");
  state = $(filter).is(':checked');
  
  for (var i=0; i<Gmaps.map.markers.length; i++) {
    marker = Gmaps.map.markers[i];
    marker_category = marker.filter_logic["quality_category"].toString();
    if (marker_category == category){
      marker.serviceObject.setVisible(state);
    }
  }
}