---
layout: post
title: Drupal Multisite, Clean URLs, and lighttpd
published: true
tags:
  - code
  - Drupal
  - Ubuntu
---

As of when this post was written, this site was running on [Drupal][]
and being served up by [lighttpd][]; it took a while to get clean URLs
working right, but what kept my server ticking was a very carefully
laid-out filesystem and set of bash scripts and lighty config files,
wrapped around a Drupal multisite installation to make installing
modules and upgrading the entire system as intuitive and painless as
possible. Upgrading Drupal (from 6.2 to the brand-new 6.3 for example)
takes no more than running a single command. Here's an overview of the
setup I used, generalized to make it applicable to almost any other
system.

As a general disclaimer, these scripts were written for a server running
[Ubuntu][] Server 8.04 "Hardy" so your filesystem layout may vary
slightly, and I'm assuming you have a general knowledge of Linux
terminology and bash commands, and that lighttpd with PHP and FastCGI
are already set up.

<!--more-->

To start off, here's how the web server file system root (`/var/www` for
me) looks:

{% gist 986210 gistfile1.txt %}

To explain briefly in words:

 *  The symlink `drupal` points to the folder of the current version of
    Drupal, so that the only thing that has to change when upgrading to
    a new version of Drupal is the one symlink.

 *  The `drupal/sites` directory points to the `drupal-sites` directory,
    which contains the `all` (and `all/modules`, where you should
    install modules for all sites to access them, and `all/themes`, the
    same as with modules except for themes) and `default` directories
    (which you'll never put anything in or do anything with, but need
    to keep around; copy it over from a freshly-downloaded Drupal).

 *  `example1.com` and `example2.com` have their own directories in
    `/var/www`; each one has three folders:
   
     *  `drupal`, which has a symbolic link (`ln -s`) pointing to it
        from `/var/www/drupal-sites` as indicated above;

     *  `files`, which is used as the upload directory with the private
        download method (if you use the public method, you can just
        leave the `files` directory in the site's `drupal` directory
        alone and omit this one);

     *  `htdocs`, which is the document root for the site pointed to by
        the site's lighttpd configuration file (explained later), and
        which points back to the Drupal directory symlink for Drupal's
        multisite handling to work.

 *  If you install [Image.module][] and want to use the [ImageMagick][]
    library, make a symlink in the `drupal/includes` directory pointing
    to the `image.imagemagick.inc` file in
    `drupal-sites/all/modules/image` (the Image.module directory) so
    that upgrading Image.module also upgrades the ImageMagick include.

Next up is configuring lighttpd. Only a couple changes need to be made
in `/etc/lighttpd/lighttpd.conf` (the global lighttpd configuration
file):

 1. Uncomment the lines with "`mod_rewrite`", "`mod_redirect`", and
    "`mod_evhost`" to enable those modules.

 2. Further down, look for a commented line beginning with
    `#evhost.path-pattern`. Uncomment it or start a new line below it,
    and write the following:
 
{% highlight text %}
evhost.path-pattern = "/var/www/%0/htdocs/"
{% endhighlight %}

Or if you're like me, and want to (a) forcibly remove "www." from the
beginning of URLs and (b) handle subdomains for each site:

{% highlight text %}
$HTTP["host"] =~ "(^|^www.)[^.]+.[^.]+$" {
    evhost.path-pattern = "/var/www/%0/htdocs/"
}
$HTTP["host"] !~ "(^|^www.)[^.]+.[^.]+$" {
    evhost.path-pattern = "/var/www/%0/%3/htdocs/"
}
{% endhighlight %}

and for each subdomain `sub.example1.com` you want to have, make the
directory `/var/www/example1.com/sub/htdocs`.

To handle Drupal's clean URLs we'll use lighttpd's [`mod_magnet`][],
which lets you use [Lua][] scripts to handle requests in lighttpd. Save
the following as `/etc/lighttpd/drupal.lua`:

{% gist 986210 drupal.lua %}

Ubuntu's lighttpd comes with a neat system for handling the
configuration for separate modules: additional configuration files can
be placed in `/etc/lighttpd/conf-available` with the naming convention
`##-NAME.conf` (the lower the two-digit number `##`, the earlier it gets
loaded), then enabled (or, symlinked in the `/etc/lighttpd/conf-enabled`
directory) with the command (as `root` or `sudo`, shown with the
standard syntax of `~#` meaning a superuser shell)

{% highlight bash %}
~# lighty-enable-mod NAME
{% endhighlight %}

replacing `NAME` with the `NAME` part of the filename of the
configuration file. After that you have to make lighttpd reload its
configuration and see the new symlink in the `conf-enabled` directory:

{% highlight bash %}
~# /etc/init.d/lighttpd force-reload
{% endhighlight %}

For example, do the following to install `mod_magnet` on Ubuntu:

{% highlight bash %}
~# apt-get install lighttpd-mod-magnet
~# lighty-enable-mod magnet
~# /etc/init.d/lighttpd force-reload
{% endhighlight %}

Installing `mod_magnet` creates the file
`/etc/lighttpd/conf-available/10-magnet.conf`, and the
`lighty-enable-mod` command creates a symlink to that file in the
`conf-enabled` directory; then lighttpd picks up the newly enabled
configuration file upon reloading.

Another use for this configuration layout is creating and keeping
separate configuration files for each domain. Drupal will install and
work up to the point before installing `mod_magnet` and creating
`drupal.lua`, but clean URLs won't work because lighttpd can't handle
directory-specific configuration files (like [Apache][]'s .htaccess
files, which Drupal is set up to handle out of the box). Instead, we'll
create a file in `/etc/lighttpd/conf-available` for each domain, and in
there tell lighttpd to use `drupal.lua` when handling requests for that
domain. For example, the file
`/etc/lighttpd/conf-available/20-example1-com.conf` might look like:

{% gist 986210 20-example1-com.conf %}

The naming convention of the file, `20-example1-com.conf`, may need a
little explaining. Actual module configurations have a priority of 10;
you want your site's configuration to load after `mod_magnet` has
loaded, so giving it a priority of 20 will have it load after all of the
default modules you have enabled (but most importantly `mod_magnet`).
Also, periods (.) are not allowed in the filenames of configuration
files, so use a dash instead between the domain name and top level
domain. Next, enable the module and reload lighttpd:

{% highlight bash %}
~# lighty-enabled-mod example1-com
~# /etc/init.d/lighttpd reload
{% endhighlight %}

And there you have it: a Drupal multisite installation served up by
lighttpd, with clean URLs fully functional (remember to enable them from
the Drupal administration page). Install modules in
`/var/www/drupal-sites/all/modules`; or put the following shell script
as `/usr/local/bin/drupal-install-mod.sh` and make it executable (`chmod
a+x`):

{% gist 986210 drupal-install-mod.sh %}

and then, to install (for example) version 6.x-1.0-alpha2 of
Image.module (Drupal project name "image"; run as `root` or `sudo`):

{% highlight bash %}
~# drupal-install-mod image-6.x-1.0-alpha2
{% endhighlight %}

then go to the Drupal modules administration page and enable the newly-downloaded module.

Now, say you've had this site running nicely for a while, then a new
version of Drupal comes out. Luckily, thanks to the filesystem layout
that keeps all of your site-specific configuration out of the Drupal
codebase directory, you don't have to manually back everything up
elsewhere; simply download the new version of Drupal, give it the
symlinks to the sites directory and ImageMagick include, update the
`/var/www/drupal` symlink to point to the new version, and delete the
old version. Or, save the following script as
`/usr/local/bin/drupal-upgrade.sh` and make it executable:

{% gist 986210 drupal-upgrade.sh %}

Modify the above for any differences in your setup (comment out the
ImageMagick section, for example), then to upgrade (for example) from
6.2 to 6.3:

{% highlight bash %}
~# drupal-upgrade 6.2 6.3
{% endhighlight %}

then visit `update.php` for each domain using Drupal in your web browser
to update the database schema. If everything borks spectacularly after
the upgrade, delete the `/var/www` directory and decompress the bzipped
tar file created by the upgrade script in `/var` to restore your file
tree to its prior state.

And there you have it. That's pretty much a full rundown of how my
server is set up; leave a comment if these instructions work for you, or
if you try it and encounter any issues, or if you get it working on
another platform besides Ubuntu and want to share what you did
differently. `drupal.lua` script and basic clean URL setup instructions
taken from [morphir.com][].

[Drupal]: http://drupal.org/
[lighttpd]: http://www.lighttpd.net/
[Ubuntu]: http://www.ubuntu.com/
[Image.module]: http://drupal.org/project/image
[ImageMagick]: http://www.imagemagick.org/script/index.php
[`mod_magnet`]: http://trac.lighttpd.net/trac/wiki/Docs:ModMagnet
[Lua]: http://www.lua.org/
[Apache]: http://httpd.apache.org/
[morphir.com]: http://web.archive.org/web/20080607103639/http://www.morphir.com/Lighttpd-Install-and-configuration-for-Drupal-with-clean-url
