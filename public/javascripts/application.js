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
      var marker_lat, marker_lng, marker_latlng, marker, siteName, services;
      marker_lat = $(this).attr("data-lat");
      marker_lng = $(this).attr("data-lng");
      marker_latlng = new google.maps.LatLng(marker_lat, marker_lng);
      marker = addMarker(marker_latlng, map, index);
      services = $(this).attr("data-services").split(",");
      siteName = $(this).find('.site-name').html();
      var directionsUrl = $(this).attr('data-directions');
      function showInfoWindow () {
          var myHtml = '<div id="info-window"><div><strong>' + siteName + '</strong></div>';
          myHtml += "<div><strong>Services Provided:</strong></div><ul class='services'>";
          $(services).each(function(i, v){
            myHtml+= "<li class='service'>"+v+"</li>";
          });
          myHtml += '</ul><a href="'+directionsUrl+'" target="_new">Get Directions</a>';
          myHtml += '</div>';

          infoWindow.setContent(myHtml);
          infoWindow.open(map, marker);
          map.panTo(marker.getPosition());
          if(map.getZoom()!=13) map.setZoom(13);
      }
      google.maps.event.addListener(marker, 'click', showInfoWindow);
      $(".marker, .address, .primary-service", this).click(showInfoWindow);
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
    $.post('/carts/remove', {id: serviceId}, function(){ 
      $(button).parents('.service-holder').slideUp().remove();
    });
  });
  
  
  $('.add-to-list form[data-remote=true]').click(function(e){
    var $this = $(this);
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


  $('.modify-site input').button();
});


$(document).ready(function(){
  function removeService(){
    $(this).parents(".single-service").remove();
    var i = selected.indexOf("affordable/transitional housing");
    selected.pop(i);
  }
  function addRemoveHandler(el){
    el.find(".remove-service").click(removeService);
  }
  function formatService(service){
    var x = "<span class=\"ui-icon ui-icon-circle-close remove-service\"></span>";
    var html = "<p class='single-service'><span class=\"ui-widget-header ui-corner-all\">" + service + x + "</span></p>";
    var input  = $("<input type='hidden' name='service[services][]' />").val(service);
    html = $(html);
    html.find(".remove-service").click(removeService);
    html.data('service', service);
    html.append(input);
    return html;
  }
  function addService(item){
    if(selected.indexOf(item.value)==-1){
      selected.push(item.value); 
      var service = item.value;
      var html = formatService(service);
      $(".selected").append(html);
    }
  }
  function gatherServices(){
    $(".single-service").each(function(e){
      var $this = $(this);
      addRemoveHandler($this);
      selected.push($this.attr("data-service"));
    });
  }

  selected = [];
  if($(".autocomplete-selector").length > 0){
    gatherServices(); //from page...
    //find and setup the show all button
    var showAll = $("#show-all");
    showAll.click(function(e){
      // var event = $.extend(true, e, {KeyCode: $.ui.keyCode.DOWN});
      var event = $.extend(true, e, {KeyCode: 65});
      $(".autocomplete-selector").val('');
      $('.autocomplete-selector').trigger("keydown.autocomplete", event);
    });
    //setup the add button
    $("#autocompleting-selector button.add").click(function(e){
      e.preventDefault();
      var completer = $('.autocomplete-selector');
      var s = completer.val();
      if(s=="") return;
      addService({value: s});
      $(completer).val("");
    }).button();
    
    $.get("/services/service_types", function(r){
      $('.autocomplete-selector').autocomplete({
        source: r,
        minLength: 0,
        delay: 0
      });
    }, 'json');
  }
  $('button.show-list-view').button().click(function(e){
    e.preventDefault();
    window.open("/carts/show");
  });
  if($('button.show-list-view').hasClass("hide")){
    $('button.show-list-view').hide()
  };
  
});
