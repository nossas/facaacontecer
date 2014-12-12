// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require modernizr
//= require foundation
//= require meurio_ui
//= require card
//= require jquery.inputmask
//= require jquery.inputmask.extensions
//= require jquery.inputmask.date.extensions

//= require angular
//= require angular-resource
//= require store
//= require moip/moip.subscription
//= require facaacontecerApp
//= require_tree ./angular

$(function(){
  $(document).foundation();

  $("li[data-orbit-slide='0']").trigger("click")

  $("#cover-orbit").on("after-slide-change.fndtn.orbit", function(event, orbit) {
    $(".cover").removeClass("cover-slider-0");
    $(".cover").removeClass("cover-slider-1");
    $(".cover").removeClass("cover-slider-2");
    $(".cover").removeClass("cover-slider-3");
    $(".cover").addClass("cover-slider-" + orbit.slide_number);
  });

  Apoie.initialize();
});
