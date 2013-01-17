require 'rack/contrib/try_static'
require 'rack/contrib/not_found'
require 'rack/rewrite'

use Rack::Rewrite do
  r301 '/blog/why-the-gop-won-t-survive-2012-and-why-a-democrat-thinks-that-s-a-bad-thing', '/blog/2012/02/20/why-the-gop-wont-survive-2012.html'
end

use Rack::TryStatic,
  :root => "_site",
  :urls => %w[/],
  :try  => ['index.html', '/index.html']

run Rack::NotFound.new('_site/404.html')
