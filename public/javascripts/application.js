// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {

  // adds onchange handlers to item name inputs that change the food select options
  jQuery('.item input.name').change(function(eventObject) {
    var select_id = this.id.split("_");
    select_id.pop();
    select_id.push("food_id");
    select_id = select_id.join("_");

    if($(this).data.selected == undefined) {
      $(this).data.selected = $("#" + select_id + " option:selected").val();
    }

    jQuery.ajax({
      data: 'name=' + this.value + '&selected=' + $(this).data.selected,
      success: function(request) { jQuery("#" + select_id).html(request); },
      type: 'post',
      url: '/foods/search_for_select'
    })
  })

})