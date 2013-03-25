---
layout: article
title: Portfolio
---

Screenshots and snippets of code and scripts from my work and pet
projects as a designer, developer, and sysadmin.

## jbhannah.net (2007-)

[You're looking at it now][jbhannah.net]. My homepage has gone through
numerous iterations over the years, often being based on WordPress,
once on Drupal, and on Ruby on Rails for a time. Hosting the site on
Drupal with lighttpd helped me learn regular expressions, and I devised
a way of enabling [clean URLs on a multisite Drupal installation on
lighttpd][drupal-lighty], which has been referenced from multiple
discussions on Drupal installation and configuration.

(old screenshots)

The current, Jekyll-based version of this site first went live in
September 2012. In March 2013 I updated it to have a responsive,
retina-friendly layout ([with inspiration from Paul Stamatiou][stammy])
built on [ZURB Foundation][zurb] using SASS. While previous iterations
had lived on shared hosts or virtual private servers, the Jekyll-based
version runs on Heroku (but is still host-agnostic). I've documented my
process for [hosting a Jekyll-based site on Heroku][jekyll-heroku], and
the entirety of this site's code is [available on GitHub][jbh-gh].

(current screenshots)

## activeG (2011-)

My primary duties at [activeG][] consist of Maximo configuration for
the installation of MapEngine (including Oracle and SQL Server script
writing), and web design and development. One of my projects was to
rewrite the activeG homepage to be easier to maintain and have a
cleaner codebase, while keeping a similar design and appearance to
the existing site; this version of the site went live as of 22 March
2013.

(screenshots)

This site is also based on ZURB Foundation, but uses static CSS and
HTML since it will need to be maintained by people without experience
beyond HTML, CSS, and JavaScript; using Jekyll or SASS would be too
complicated, so those were ruled out, at the expense of keeping the
code from being fully semantic.

## thetallgrass.net (2013-)

The first website I ever built (and what I first learned HTML for) was
a Pokémon website, which I launched in 2001. It went through a few
different versions over the next few years, and the last of those
(2004-2005) was my first time building a website in PHP.
[thetallgrass.net][] is in part a Rails-based relaunch of that website,
while also aiming to be the most modern fan site, database, and
community on a subject where most sites are still stuck in the early
2000s. It is [fully open-source and available on GitHub][ttg-gh], and
is under active development for an October 2013 launch.

[jbhannah.net]: {{ site.url }}
[drupal-lighty]: {% post_url 2008-07-10-drupal-multisite-clean-urls-and-lighttpd %}
[stammy]: http://paulstamatiou.com/responsive-retina-blog-development-part-2
[zurb]: http://foundation.zurb.com/
[jekyll-heroku]: {% post_url 2013-01-16-jekyll-on-heroku-without-rack-jekyll-or-custom-buildpacks %}
[jbh-gh]: https://github.com/jbhannah/jbhannah.net
[activeG]: http://www.activeg.com/
[thetallgrass.net]: http://thetallgrass.net/
[ttg-gh]: https://github.com/thetallgrassnet/thetallgrass.net
