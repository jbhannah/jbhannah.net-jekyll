require 'rack/contrib/try_static'
require 'rack/contrib/not_found'
require 'rack/rewrite'

use Rack::Deflater

use Rack::Rewrite do
  r301 '/blog/why-the-gop-won-t-survive-2012-and-why-a-democrat-thinks-that-s-a-bad-thing', '/blog/2012/02/20/why-the-gop-wont-survive-2012.html'
  r301 %r{.*}, 'http://jbhannah.net$&', :if => Proc.new {|rack_env|
    ENV['RACK_ENV'] == "production" && rack_env['SERVER_NAME'] != 'jbhannah.net'
  }
end

use Rack::TryStatic,
  urls: %w[/],
  root: "_site",
  try: ['index.html', '/index.html'],
  header_rules: [
    ["/assets", {'Cache-Control' => 'public, max-age=31536000'}]
  ]

run Rack::NotFound.new('_site/404.html')
