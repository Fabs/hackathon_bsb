var directionService = new google.maps.DirectionsService();
var rboxer = new RouteBoxer();
var detour = $("#detour").attr("value");
var debug = false;
var global_google;

function find_bounds(){
  var request = {
    origin: $("#parameter_from").attr("value"),
    destination: $("#parameter_to").attr("value"),
    travelMode: google.maps.DirectionsTravelMode.DRIVING
  }

  directionService.route(request, function(result, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      var path = result.routes[0].overview_path;
      var boxes = rboxer.box(path, detour);
    
      if (debug){
        drawBoxes(boxes);
      }
      
      request_new_markers_from_boxes( boxes_to_json(boxes));
    }else {

    }
  });

  function drawBoxes(boxes) {
   boxpolys = new Array(boxes.length);
   for (var i = 0; i < boxes.length; i++) {
     boxpolys[i] = new google.maps.Rectangle({
     bounds: boxes[i],
       fillOpacity: 0,
       strokeOpacity: 1.0,
       strokeColor: '000000',
       strokeWeight: 1,
       map: Gmaps.map.serviceObject,
     });
   }
  }
  
  function boxes_to_json(boxes){
    var hash = {};
    var box_array = new Array();    
    for (var i = 0; i < boxes.length; i++) {
      var bounds = boxes[i];
      box_array[i] = [[bounds.Z.b,bounds.ca.b],[bounds.Z.d,bounds.ca.d]];
    } 
    hash["_json"] = box_array;
    return hash;
  }
  
  function request_new_markers_from_boxes(json_data){
    jQuery.ajax({
        type: "POST",
        url: '/near_route',
        data: JSON.stringify(json_data),
        success: function(data) {
          Gmaps.map.addMarkers(JSON.parse(data[0]));
          for (var i=0; i<Gmaps.map.markers.length; i++) {
            marker = Gmaps.map.markers[i];
          }
          best_school_id = data[1];
          average = data[2][0]
          deviation = data[2][1]
          Gmaps.map.map.panBy(-1*0.1*$("html").width(),0)                                  
          install_filters();
        },
        dataType: "json",
        contentType: "application/json",
        processData: false
    });
  }
}

Gmaps.map.callback = function() {
  global_google = google;
   google.maps.event.addListenerOnce(Gmaps.map.serviceObject, 'idle', function(){
     find_bounds();
   });
}