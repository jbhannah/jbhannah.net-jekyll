---
layout: default
title: Portfolio
---

# Portfolio

Most designers have mostly a graphical portfolio; mine also includes
code and scripts, links to blog posts and GitHub in addition to
screenshots. Design, programming, and systems administration have all
been of roughly equal importance to my development experience, both
professionally and as a hobbyist, and being well-rounded influences my
approach to each of the three aspects of development.

## jbhannah.net (2012)

[You're looking at it now][jbhannah.net]. My homepage has gone through
numerous iterations over the years, often being based on WordPress,
once on Drupal, and on Ruby on Rails for a time. The current,
Jekyll-based version first went live in September 2012.

(old screenshots)

In March 2013 it was updated with a responsive, retina-friendly layout
([with inspiration][stammy] from Paul Stamatiou) built on [ZURB
Foundation][zurb] using SASS. While previous iterations had lived on
shared hosts or virtual private servers, the Jekyll-based version runs
on Heroku (but is still host-agnostic). I've documented my process for
[hosting a Jekyll-based site on Heroku][jekyll-heroku].

(current screenshots)

## activeG Homepage (2013)

My primary duties at activeG consist of Maximo configuration for the
installation of MapEngine (including Oracle and SQL Server script
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
[stammy]: http://paulstamatiou.com/responsive-retina-blog-development-part-2
[zurb]: http://foundation.zurb.com/
[jekyll-heroku]: {% post_url 2013-01-16-jekyll-on-heroku-without-rack-jekyll-or-custom-buildpacks %}
