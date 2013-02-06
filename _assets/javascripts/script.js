//= require vendor/modernizr

$(function() {
  $('a[href^=http]').each(function() {
    if (this.href.indexOf("http://" + location.hostname) == -1) {
      var rel = $(this).attr('rel');
      if (rel != undefined) {
        rel += ' ';
      } else {
        rel = '';
      }
      $(this).attr('rel', rel + 'external');
    }
  });

  $('a[rel~=external]').attr('target', '_blank').click(function() {
    _gaq.push(['_trackEvent', 'Outbound Links', $(this).href, $(this).text]);
  });
});
