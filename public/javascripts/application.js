// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {

  /*----------------------------------------------------------------------
   * Highslide configs
   *--------------------------------------------------------------------- */

  // same as default, but with a preceding '/'
  hs.graphicsDir = "/highslide/graphics/";
  hs.showCredits = false;

  /*----------------------------------------------------------------------
   * adds onchange handlers to item name inputs that change the food select options
   *-------------------------------------------------------------------- */
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

  /*----------------------------------------------------------------------
   * Make .circle use qtip for tooltips
   *-------------------------------------------------------------------- */
  $(".circle").qtip();

  /*----------------------------------------------------------------------
   * Use the tooltip attribute of an element for tooltip content
   *-------------------------------------------------------------------- */
  $('#content [tooltip]').each(function() {
    $(this).addClass('tooltip-able')
    $(this).qtip({
      content: $(this).attr('tooltip'),
      style: { width: 250 }
    });
  });

  /*----------------------------------------------------------------------
   * WYSIWYM, setup is fairly undocumented, but clean (got this from the source
   * code at http://pk-designs.com/notebook/rolling-my-own-wysiwym-editor/)
   *-------------------------------------------------------------------- */
  $('#recipe_directions').wysiwym(WysiwymMarkdown, 'wysiwymComment');
  
  /*----------------------------------------------------------------------
   * Set up recipe directions Live Preview
   *-------------------------------------------------------------------- */
  function markupPreviewLoop() {
      // Update the Comment Markup
      var markupText = $('#recipe_directions').val().escapeHTML();
      if (markupText == '') { markupText = "&nbsp;"; }
      if (typeof(previousMarkupText) == "undefined" || markupText != previousMarkupText) {
          var converter = new Showdown.converter();
          var markupHtml = converter.makeHtml(markupText);
          $('#recipe_directions_preview').html(markupHtml);
          previousMarkupText = markupText;
      }
      setTimeout(markupPreviewLoop, 100);
  }
  if ($('#recipe_directions').val() != undefined) { markupPreviewLoop() };

})

/*----------------------------------------------------------------------
 * Additional Javascript Prototypes
 *-------------------------------------------------------------------- */
String.prototype.escapeHTML = function() {                                       
    return(this.replace(/&/g,'&amp;').replace(/>/g,'&gt;').
        replace(/</g,'&lt;').replace(/"/g,'&quot;'));
};