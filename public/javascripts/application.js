// Put your application scripts here

function addMarker (latLng, map, i){
  return new google.maps.Marker({
    position: latLng,
    map: map,
    icon: "http://maps.google.com/mapfiles/marker" + String.fromCharCode(i + 65) + ".png"
  });
}


$(document).ready(function(){
  $("[data-method=map]").each(function () {
    var lat, lng, map, latLng, infoWindow = new google.maps.InfoWindow();
    lat = $(this).attr("data-lat");
    lng = $(this).attr("data-lng");

    latLng = new google.maps.LatLng(lat,lng);
    var myOptions = {
      center: latLng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(this, myOptions);

    var bounds = new google.maps.LatLngBounds();
    $('.mapable').each(function(index, el){
      var marker_lat, marker_lng, marker_latlng, marker, siteName, service;
      marker_lat = $(this).attr("data-lat");
      marker_lng = $(this).attr("data-lng");
      marker_latlng = new google.maps.LatLng(marker_lat, marker_lng);
      marker = addMarker(marker_latlng, map, index);
      service = $(this).find('.primary-service').html();
      siteName = $(this).find('.site-name').html();
      function showInfoWindow () {
          var myHtml = '<div class="info-window"><div>' + siteName + '</div><div>' + service+'</div></div>';
          infoWindow.setContent(myHtml);
          infoWindow.open(map, marker);
          map.panTo(marker.getPosition());
          if(map.getZoom()!=13) map.setZoom(13);
      }
      google.maps.event.addListener(marker, 'click', showInfoWindow);
      $(".marker", this).click(showInfoWindow);
      bounds.extend(marker_latlng);
    });

    if($(this).attr('data-zoom')){
      var z=$(this).attr('data-zoom');
      map.setZoom(parseInt(z));
    } 
    else{
      map.fitBounds(bounds);
    }
  });  

  $('select ~ .select-other').prev().change(function (){
    if($(this).val() == "Other"){
      $(this).next('.select-other').show().find('input').attr('disabled', false).val("");
    }
    else{
      $(this).next('.select-other').hide().find('input').attr('disabled', true);
    }
  });
  
  $('[data-remote=true]').each(function(){
    
  });

  function confirmSubmit (argument) {
    var message = $(this).attr('data-confirm');
    if(message===undefined){
      message = "Are you sure?";
    };
    return confirm(message);
  };

  $('[confirm=true]').click(confirmSubmit);//.submit(confirmSubmit);
  
  $('[data-remote=true]').click(function(){
    var url = $(this).attr('action');
    var method = $(this).attr('method');
    $.ajax({
      method: method,
      url: url,
      success: function(){alert("I'm Back!"); }
    });
    return false;
  });
  
});
