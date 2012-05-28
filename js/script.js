$(function() {
  $('a[href^="http"]').attr({
    rel:    'external'
   ,target: '_blank'
  }).click(function() {
    _gaq.push(['_trackEvent', 'Outbound Links', $(this).href, $(this).text]);
  });
});
