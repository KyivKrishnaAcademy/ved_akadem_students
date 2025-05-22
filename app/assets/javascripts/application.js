// DO NOT REQUIRE jQuery or jQuery-ujs in this file!
// DO NOT REQUIRE TREE!

// CRITICAL that generated/vendor-bundle must be BEFORE bootstrap-sprockets and turbolinks
// since it is exposing jQuery and jQuery-ujs

//= require generated/vendor-bundle

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery_nested_form

// bootstrap-sprockets depends on generated/vendor-bundle for jQuery.
//= require bootstrap-sprockets

//= require jquery-ui/widgets/autocomplete
//= require select_2_initializers
//= require moment
//= require moment/ru
//= require moment/uk
//= require custom
//= require stop_double_submit
//= require change_academic_group
//= require sidebar
