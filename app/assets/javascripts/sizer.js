function resize_map(){
  $(".resizable").width("170px");
  
  $(".span6.resizable").parent().css("left","20%");
  
  $(".removable").hide();
  $(".map_container").width("50%");
  $(".map_container").css("border-right","1px solid gray");  
  
  Gmaps.map.map.panBy(0.28*$("html").width(),0)                                  
}

$(".logo").click(function (){
  resize_map();
  return false;
});