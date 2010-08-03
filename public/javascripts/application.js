// Put your application scripts here

function initMap(lat, lng) {
  var latlng = new google.maps.LatLng(lat,lng);
  var myOptions = {
    zoom: 12,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("map"), myOptions);
  
}

function addMarker (latLng,  map){
  var marker = new google.maps.Marker({
    position: latLng,
    map: map
  });
}
$(document).ready(function(){
  $("[data-method=map]").each(function () {
    var lat, lng, map, latLng;
    lat = $(this).attr("data-lat");
    lng = $(this).attr("data-lng");
    var latlng = new google.maps.LatLng(lat,lng);
    var myOptions = {
      zoom: 15,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    map = new google.maps.Map(this, myOptions);
    addMarker(latlng, map);
  });  
  
  $('select ~ .select-other').prev().change(function (){
    if($(this).val() == "Other"){
      $(this).next('.select-other').show().find('input').attr('disabled', false).val("");
    }
    else{
      $(this).next('.select-other').hide().find('input').attr('disabled', true);
    }
  });
  
  $('#map').each(function(){
    
  })
  
});
