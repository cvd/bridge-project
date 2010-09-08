/*
	# This script injects the GWU topHat on any page that has a <body> and supports javascript
	# You must have jQuery included in the parent HTML file as well as this script.  Use:
	# <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
	# before including this script in your HTML <head></head> tag area.
*/

//what's the root location of the CSS and JS?
var rootLocation = 'http://72.167.43.64/sitedev/';

$(document).ready(function()
{
	
	/*  
		# unfortunately we can't just grab the HTML from an external server, so we have to use static HTML here as the content:
		# this HTML content is updated and kept here: http://dev.christopherrcooper.com/gwu/templaton.php?getModuleHTML=73
	*/
	
	var content = '<div id="container"><div id="header"><div id="topHat"><div id="logo"><a href="#">The George Washington University | Washington DC</a></div><div id="mainMenu"><ul class="parent"><li class="first"><a href="#">GW Home</a></li><li><a class="parent secondaryMenuOne">GW Links</a><ul class="child"><li><a href="#">Explore</a><ul class="grandChild"><li class="first"><a href="#">About GW</a></li><li><a href="#">Academic Life</a></li><li><a href="#">Campus Life</a></li><li><a href="#">GW Athletics</a></li><li><a href="#">Media Room</a></li><li><a href="#">Visiting Campus</a></li><li><a href="#">GW Today</a></li></ul></li><li><a href="#">Apply</a><ul class="grandChild"><li class="first"><a href="#">Undergraduate Admissions</a></li><li><a href="#">Academic Life</a></li><li><a href="#">Campus Life</a></li><li><a href="#">GW Athletics</a></li><li><a href="#">Media Room</a></li><li><a href="#">Visiting Campus</a></li><li><a href="#">GW Today</a></li></ul></li><li><a href="#">Learn</a><ul class="grandChild"><li class="first"><a href="#">Colleges &amp; Schools</a></li><li><a href="#">Academic Life</a></li><li><a href="#">Campus Life</a></li><li><a href="#">GW Athletics</a></li><li><a href="#">Media Room</a></li><li><a href="#">Visiting Campus</a></li><li><a href="#">GW Today</a></li></ul></li><li><a href="#">Discover</a><ul class="grandChild"><li class="first"><a href="#">Discoveries &amp; Innovations</a></li><li><a href="#">Academic Life</a></li><li><a href="#">Campus Life</a></li><li><a href="#">GW Athletics</a></li><li><a href="#">Media Room</a></li><li><a href="#">Visiting Campus</a></li><li><a href="#">GW Today</a></li></ul></li><li><a href="#">Connect</a><ul class="grandChild"><li class="first"><a href="#">Alumni</a></li><li><a href="#">Academic Life</a></li><li><a href="#">Campus Life</a></li><li><a href="#">GW Athletics</a></li><li><a href="#">Media Room</a></li><li><a href="#">Visiting Campus</a></li><li><a href="#">GW Today</a></li></ul></li><li><a href="#">Give</a><ul class="grandChild"><li class="first"><a href="#">The Power of Giving</a></li><li><a href="#">Academic Life</a></li><li><a href="#">Campus Life</a></li><li><a href="#">GW Athletics</a></li><li><a href="#">Media Room</a></li><li><a href="#">Visiting Campus</a></li><li><a href="#">GW Today</a></li></ul></li><li class="close"><a>Close</a></li></ul></li><li><a class="parent secondaryMenuTwo">Info For</a><ul class="child secondaryMenuTwo"><li class="students"><a href="#">Students</a><ul class="grandChild"><li class="first parted1"><a href="#">GWMail</a></li><li class="parted2"><a href="#">Blackboard</a></li><li class="parted3"><a href="#">GWeb (Records &amp; Registration)</a></li><li class="parted4"><a href="#">GWired (Student Services)</a></li><li class="parted5"><a href="#">myGW Portal</a></li><li class="parted6"><a href="#">Colonial Central (Financial Services)</a></li><li class="parted7"><a href="#">GWorld Card and Colonial Cash</a></li><li class="parted8"><a href="#">GW Bulletin (Course Descriptions)</a></li><li class="parted9"><a href="#">University Libraries</a></li><li class="parted10"><a href="#">GW Bookstore</a></li></ul></li><li><a href="#">Alumni</a><ul class="grandChild"><li class="first"><a href="#">Undergraduate Admissions</a></li><li><a href="#">Connect &amp; Share</a></li><li><a href="#">Benefits &amp; Services</a></li><li><a href="#">Programs &amp; Events</a></li><li><a href="#">Volunteer &amp; Give</a></li><li><a href="#">Transcript Services</a></li></ul></li><li><a href="#">Faculty and Staff</a><ul class="grandChild"><li class="first"><a href="#">Colleges &amp; Schools</a></li><li><a href="#">Academic Life</a></li><li><a href="#">Campus Life</a></li><li><a href="#">GW Athletics</a></li><li><a href="#">Media Room</a></li><li><a href="#">Visiting Campus</a></li><li><a href="#">GW Today</a></li></ul></li><li><a href="#">Parents</a><ul class="grandChild"><li class="first"><a href="#">Discoveries &amp; Innovations</a></li><li><a href="#">Academic Life</a></li><li><a href="#">Campus Life</a></li><li><a href="#">GW Athletics</a></li><li><a href="#">Media Room</a></li><li><a href="#">Visiting Campus</a></li><li><a href="#">GW Today</a></li></ul></li><li class="close"><a>Close</a></li></ul></li></ul></div><div id="search"><form method="post" action="#"><fieldset><div class="inputHolder"><label for="searchInput">Search String:</label><input id="searchInput" type="text" value="SEARCH" /><div class="selectHolder"><label for="myselectbox">Select Site to Search:</label><select id="myselectbox" name="myselectbox" tabindex="2"><option value="1">CCAS</option><option value="2" selected="selected">GW</option><option value="3">Law</option></select></div></div><button type="submit" class="pointer">go</button></fieldset></form></div></div></div></div>';
	
	//now prepend the body with the content
	$('body').prepend(content);
	
	//now add the JS and CSS since everything else is loaded...
	$.getScript(rootLocation+"js/jquery.selectbox-0.5.js", function(){
		$.getScript(rootLocation+"js/topHat.js", function(){
   			//gathered the necessary JS support files...
		});	
	});
	
	//add the necessary css...        
    $('head').prepend('<link rel="stylesheet" type="text/css" href="'+rootLocation+'css/selectbox.css" media="screen" />');
	$('head').prepend('<link rel="stylesheet" type="text/css" href="'+rootLocation+'css/topHat.css" media="screen" />');
});