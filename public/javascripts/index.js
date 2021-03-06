  $.getJSON('/all_services.json', function(data) {
    element = $('#map_all_of_the_things')[0];

    var lat, lng, latLng, infoWindow = new google.maps.InfoWindow();
    lat = $(element).attr("data-lat");
    lng = $(element).attr("data-lng");
    latLng = new google.maps.LatLng(lat,lng);
    var myOptions = {
      streetViewControl: false,
      mapTypeControl: false,
      center: latLng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(element, myOptions);

    var bounds = new google.maps.LatLngBounds(); 

   $.each(data, function(ind, svc) {
      var marker_lat, marker_lng, marker_latlng, marker, siteName, services;
      marker_lat = svc.lat;

      marker_lng = svc.lng;
      marker_latlng = new google.maps.LatLng(marker_lat, marker_lng);
      marker = addMarker(marker_latlng, map);
      var name = svc.site_name;
      var services = svc.services;
      
    //  siteName = $(svc).find('.site-name').html();
      function showInfoWindow () {
        var myHtml = '<div id="info-window"><div><strong><a href="/services/show/'+svc._id+'">' + name + '</a></strong></div>';
          myHtml += "<ul>";
            $(services).each(function(){
            myHtml += "<li>";
            myHtml += this;
            myHtml += "</li>";
          });
          myHtml += "<ul>";
          myHtml += '</div>';

          infoWindow.setContent(myHtml);
          infoWindow.open(map, marker);
          map.panTo(marker.getPosition());
          //if(map.getZoom()!=11) map.setZoom(11);
      }
     google.maps.event.addListener(marker, 'click', showInfoWindow);
     bounds.extend(marker_latlng);
    });
    
    map.fitBounds(bounds);

    //name
    //category
    //link to show all


});

$(document).ready(function(){
  var geocoder, point;
  var addressMarker;
  var infoWindow = new google.maps.InfoWindow();
  function showAddress(address) {

    if (geocoder) {
      geocoder.geocode(
        {address: address},
        function(results, status) {
          if (status == google.maps.GeocoderStatus.OK) {
            point = results[0].geometry.location;
            setTimeout(function(){
              addressMarker = addMarker(point, map, null, google.maps.Animation.DROP, '/images/marker-green.png');
              function showInfoWindow () {
                var myHtml = '<div id="info-window"><div><strong>Your Location</strong></div></div>';
                  infoWindow.setContent(myHtml);
                  infoWindow.open(map, addressMarker);
                  map.panTo(addressMarker.getPosition());
              }
              google.maps.event.addListener(addressMarker, 'click', showInfoWindow);
            }, 200);
            map.setCenter(point, 13);
            map.setZoom(15);
          } else {
            alert(address + " not found");
          }
        }
      );
    }
    return false;
  }
  geocoder = new google.maps.Geocoder();
  $("form#focus").submit(function(e){
    e.preventDefault();
    showAddress($("#address").val());
  });
});


