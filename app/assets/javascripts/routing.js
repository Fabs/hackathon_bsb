var directionService = new google.maps.DirectionsService();
var rboxer = new RouteBoxer();
var distance = 0.5; // km
var debug = false;

function find_bounds(){
  var request = {
    origin: $("#parameter_from").attr("value"),
    destination: $("#parameter_to").attr("value"),
    travelMode: google.maps.DirectionsTravelMode.DRIVING
  }

  directionService.route(request, function(result, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      var path = result.routes[0].overview_path;
      var boxes = rboxer.box(path, distance);
    
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
          Gmaps.map.addMarkers(data);
        },
        dataType: "json",
        contentType: "application/json",
        processData: false
    });
  }
}

Gmaps.map.callback = function() {
   google.maps.event.addListenerOnce(Gmaps.map.serviceObject, 'idle', function(){
     find_bounds();
     Gmaps.map.map.setZoom(Gmaps.map.map.zoom -1);
   });
}
