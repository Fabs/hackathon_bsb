var resized = false;
function resize_map(){
  $(".resizable").width("170px");
  
  $(".span6.resizable").parent().css("left","20%");
  
  $(".removable").hide();
  $(".map_container").width("50%");
  $(".map_container").css("border-right","1px solid gray");  
  $(".map_container").css("display","inline-block");  
  
  Gmaps.map.map.panBy(0.28*$("html").width(),0)    
  google.maps.event.trigger(Gmaps.map, 'resize');
  
}

function info_for_school(school_id){
  $.get("/escola/"+school_id+"/details", function(){
    
  });
}

$(document).on("click",".btn-resize",function() {
  school_id = $(this).attr("school-id");
  if (! resized){
    resize_map();  
    resized = true;
  }
  
  info_for_school(school_id);
  return false;
});