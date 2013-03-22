---
layout: article
title: Portfolio
---

Most designers have mostly a graphical portfolio; mine also includes
code and scripts, links to blog posts and GitHub in addition to
screenshots. Design, programming, and systems administration have all
been of roughly equal importance to my development experience, both
professionally and as a hobbyist, and being well-rounded influences my
approach to each of the three aspects of development.

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

## thetallgrass.net (2013)

[jbhannah.net]: {{ site.url }}
[drupal-lighty]: {% post_url 2008-07-10-drupal-multisite-clean-urls-and-lighttpd %}
[stammy]: http://paulstamatiou.com/responsive-retina-blog-development-part-2
[zurb]: http://foundation.zurb.com/
[jekyll-heroku]: {% post_url 2013-01-16-jekyll-on-heroku-without-rack-jekyll-or-custom-buildpacks %}
[jbh-gh]: https://github.com/jbhannah/jbhannah.net
[activeG]: http://www.activeg.com/
