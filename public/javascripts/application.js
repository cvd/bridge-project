// Put your application scripts here
$(document).ready(function(){

  function addMarker (latLng, map, i){
    return new google.maps.Marker({
      position: latLng,
      map: map,
      icon: "http://maps.google.com/mapfiles/marker" + String.fromCharCode(i + 65) + ".png"
    });
  }
  
  
  $("[data-method=map]").each(function () {
    var lat, lng, map, latLng, infoWindow = new google.maps.InfoWindow();
    lat = $(this).attr("data-lat");
    lng = $(this).attr("data-lng");

    latLng = new google.maps.LatLng(lat,lng);
    var myOptions = {
      streetViewControl: false,
      mapTypeControl: false,
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
    GLOB = map;
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
  
  $("button.remove-from-list").click(function(){
    var button = this;
    var serviceId = $(this).attr('service-id');
    $.post('/carts/remove', {id: serviceId}, function(){ $(button).parents('.service-holder').slideUp().remove();})
  });
  
  
  $('.add-to-list form[data-remote=true]').click(function(e){
    $this = $(this);
    var url = $this.attr('action') + "?";
    url += $this.serialize();
    var method = $this.attr('method');
    method = method || "get";
    $.ajax({
      method: method,
      url: url,
      success: function(){ 
        $this.slideUp();
        $('.add-to-list .added-holder').slideDown();
        $(".show-list-view").show();
      },
      error: function(){ alert('Error adding service to list');}
    });
    e.preventDefault();
  }).find('button').button().click(function(){});

  $(".autocomplete-selector").each(function(){
    var selected = [];
    $.get("/services/service_types", function(r){
      $('.autocomplete-selector')
        .autocomplete({
           source: r, 
           minLength: 0,
           select: function(event, ui) { 
             if(selected.indexOf(this.value)) selected.push(this.value); 
             console.log(selected);
             var span = "<span  class=\"ui-widget-header ui-corner-all\" style=\"padding: 4px; margin-left: 4px;\">";
             
             $(".selected").html(span + selected.join("</span>" + span) + "</span>");
           }
         });
    }, 'json');    
  })
  
  $('button.show-list-view').button().click(function(e){
    e.preventDefault();
    window.open("/carts/show");
  });
  
  
});
