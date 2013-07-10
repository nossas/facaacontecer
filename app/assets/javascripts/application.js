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
//= require select2
//= require parsley
//= require jquery_ujs
//= require foundation
//= require jquery.to_json
//= require jquery.mask
//= require jquery.colorbox
//= require jquery.placeholder
//= require moip.subscription
//= require best_in_place
//= require selfstarter 
//= require_tree .

$(function(){ $(document).foundation(); });
var ts = $.tablesorter,
    sorting = false,
    searching = false;

$('table')
    .on('sortBegin filterEnd', function (e, filters) {
        if (!(sorting || searching)) {
            var table = this,
                c = table.config,
                filters = ts.getFilters(table),
                $sibs = c.$table.siblings('.tablesorter');
            if (!sorting) {
                sorting = true;
                $sibs.trigger('sorton', [c.sortList, function () {
                    setTimeout(function () {
                        sorting = false;
                    }, 500);
                }]);
            }
            if (!searching) {
                $sibs.each(function () {
                    ts.setFilters(this, filters, true);
                });
                setTimeout(function () {
                    searching = false;
                }, 500);
            }
        }
    })
    .tablesorter({
        theme: 'blue',
        widthFixed: true,
        widgets: ['filter']
    });

$(document).ready(function() {
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();
});
