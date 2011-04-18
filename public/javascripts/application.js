// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery(document).ready(function() {
	//menu01
	jQuery("a.menu01").hover(function(){
		jQuery(".gnavi_child").addClass("child01_bg");
		jQuery(".gnavi_child").removeClass("child02_bg");
		jQuery(".gnavi_child").removeClass("child03_bg");
		jQuery(".gnavi_child").removeClass("child04_bg");
		jQuery("ul.child01").show();
		jQuery("ul.child02").hide();
		jQuery("ul.child03").hide();
		jQuery("ul.child04").hide();
	});
	
	//menu02
	jQuery("a.menu02").hover(function(){
		jQuery(".gnavi_child").removeClass("child01_bg");
		jQuery(".gnavi_child").addClass("child02_bg");
		jQuery(".gnavi_child").removeClass("child03_bg");
		jQuery(".gnavi_child").removeClass("child04_bg");
		jQuery("ul.child01").hide();
		jQuery("ul.child02").show();
		jQuery("ul.child03").hide();
		jQuery("ul.child04").hide();
	});
	
	//menu03
	jQuery("a.menu03").hover(function(){
		jQuery(".gnavi_child").removeClass("child01_bg");
		jQuery(".gnavi_child").removeClass("child02_bg");
		jQuery(".gnavi_child").addClass("child03_bg");
		jQuery(".gnavi_child").removeClass("child04_bg");
		jQuery("ul.child01").hide();
		jQuery("ul.child02").hide();
		jQuery("ul.child03").show();
		jQuery("ul.child04").hide();
	});
	
	//menu04
	jQuery("a.menu04").hover(function(){
		jQuery(".gnavi_child").removeClass("child01_bg");
		jQuery(".gnavi_child").removeClass("child02_bg");
		jQuery(".gnavi_child").removeClass("child03_bg");
		jQuery(".gnavi_child").addClass("child04_bg");
		jQuery("ul.child01").hide();
		jQuery("ul.child02").hide();
		jQuery("ul.child03").hide();
		jQuery("ul.child04").show();
	});
	
	//Twitter、マイページテーブルの縞模様
	jQuery(".twitter_lists li:even").addClass("even");
	jQuery(".my_tablestyle01 tr:even").addClass("even");
});

function set_position(id, p){
  jQuery("#page_"+id+"_latitude").val(p.lat());
  jQuery("#page_"+id+"_longitude").val(p.lng());
  jQuery("#page_"+id+"_latitude_label").text(p.lat());
  jQuery("#page_"+id+"_longitude_label").text(p.lng());
}
