var directionService = new google.maps.DirectionsService();
var rboxer = new RouteBoxer();
var distance = 1; // km
var debug = true;

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
      
      var json_data = boxes_to_json(boxes)
            
      $.post(
        "/near_route",
        json_data,
        function(data) {
          alert("Response: " + data);
      });
            
    }else {
        alert("fail!");
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
    var json_data = new Array();
    for (var i = 0; i < boxes.length; i++) {
      var bounds = boxes[i];
      json_data[i] = [bounds.Z.b,bounds.ca.b],[bounds.Z.d,bounds.ca.d];
    } 
    
    return JSON.stringify(json_data);
  }
}

Gmaps.map.callback = function() {
   google.maps.event.addListenerOnce(Gmaps.map.serviceObject, 'idle', function(){
     find_bounds();
     Gmaps.map.map.setZoom(Gmaps.map.map.zoom -1);
   });
}
