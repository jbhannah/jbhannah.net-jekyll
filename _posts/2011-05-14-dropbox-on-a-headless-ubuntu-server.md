---
layout: post
title: Dropbox on a Headless Ubuntu Server
published: true
tags:
  - Linux
---

The first computer of my own that I've had was a Compaq desktop that,
at the time, was relatively high-end: 3.0 GHz Pentium 4 processor with
hyper-threading, 512 MiB[^MiB] of RAM, 160 GB hard drive, DVD and CD-RW
drives, and 128 MiB graphics card. I got it in 2003; since then, it's
had its hard drive poorly partitioned from my first forays into Linux
([Fedora][fdra] Core 1), was the local web server on which I began
teaching myself [PHP][php], been used by my brother for almost two
years as his computer after I got my Mac and moved up to Tempe to start
at ASU, until he got his own computer, and had countless games and
programs installed on it. Once my brother got his current desktop, the
old Compaq fell mostly into disuse until I decided to bring it up here;
and after sitting in my living room running basically nothing but
[BOINC][boinc], I've finally begun putting it to good active use.

Now, it's running [Ubuntu Server][ubsrv] 11.04, connected only to my
home network (without a monitor, or "headless"), and acting as a
[Transmission][xmsn] client, local [Apache HTTP][httpd] and
[MySQL][mysql] server, [AFP][afp] [file server][afp2] (via
[Netatalk][natlk]), and IPv6 gateway with a
[Hurricane Electric IPv6 tunnel][he] and [radvd][radvd]. Most of that
is pretty straightforward; instructions on setting up AFP are in the
middle of that wall of links, and an IPv6/radvd how-to is forthcoming,
but I also have it connected to my Dropbox account with the idea of
having it be a host for backups of itself and my web server and
automatically managing and uploading the backups. I don't quite have
the backup system figured out yet (when I do I'll put together a
writeup on that, too), but I have got Dropbox up and running smoothly.
Most of this is based on instructions from the Dropbox wiki, both for a
[generic Linux text-based installation][db-gi] and
[for Ubuntu Server][db-us], but with a few refinements. I've put
together a [script][setup] (which should be run as `root` or with
`sudo`) that goes through the whole process, which is pretty
straightforward but I'll go over the steps here. (They're written for
and have only been tested on Ubuntu Server, but will probably work on
most other distributions; the only thing that might need to be changed
is the startup script.)

<!--more-->

First, obviously, is to download the Dropbox client itself. This will
download the latest stable Linux client and extract it to
`/usr/local/dropbox`, which you can change if you want to install the
client elsewhere; and if your machine is 64-bit, you can replace `x86`
in the download URL with `x64`. (Again, you need to be `root` or `sudo`
to run these.)

{% highlight bash %}
mkdir -p /usr/local/dropbox
wget -qO- http://www.dropbox.com/download/?plat=lnx.x86 | tar xz --strip 1 -C /usr/local/dropbox
{% endhighlight %}

The client will be running as a sandboxed user `dropbox` (and group by
the same name); it'll be a system user and will (almost) never need to
log in, and its home directory will be at `/etc/dropbox`, which is
where Dropbox configuration and your files will live.

{% highlight bash %}
useradd -r -m -d /etc/dropbox -U -s /bin/false dropbox
chown dropbox.dropbox /etc/dropbox
chmod 700 /etc/dropbox
{% endhighlight %}

This is the only time you should need to actually use a shell as the
`dropbox` user: to link the computer to your Dropbox account. Open a
`bash` session as `dropbox`, set permissions, and run `dropboxd`.

{% highlight bash %}
su -l dropbox -s /bin/bash
umask 0027
/usr/local/dropbox/dropboxd
{% endhighlight %}

This will complain and tell you that this computer is not connected to
any account, and will repeat a message every few seconds that looks
like:

{% highlight text %}
This client is not linked to any account... Please visit https://www.dropbox.com/cli_link?host_id=verylongstring to link this machine.
{% endhighlight %}

This message contains a URL; open it in any web browser---text-based on
the server itself, in another login shell or `screen` session, or on
the nearest available desktop---and you'll be prompted to sign in to
your Dropbox account. `dropboxd` on the server will tell you that it's
been paired to your account; you can then stop it with `Ctrl-C` and
exit the `dropbox` user session.

The last thing to do is to start Dropbox when the server starts up. For
Ubuntu, the primary init daemon is [Upstart][upst]; the following is a
script that you can save to `/etc/init/dropbox.conf` which will
automatically start Dropbox as the `dropbox` user as a background
process when the server starts up. (The [Dropbox wiki][db-gi] has
instructions or hints for other distributions' init daemons.)

{% gist 986199 dropbox.conf %}

In a nutshell, this tells the system to:

 1. Start Dropbox at the normal time for regular programs during
    startup, and revive it if it quits unexpectedly (without being told
    to stop by Upstart during shutdown or with `stop dropbox`).
 2. Use the `dropbox` user's home folder, and ensure that permissions
    are correctly set.
 3. Make sure there are no stray sockets left over from a previous
    instance of Dropbox.
 4. Use the UTF-8 locale (this ensures that files with non-ASCII
    characters in their filenames download correctly).
 5. Start Dropbox as the `dropbox` user.

With the Upstart script in place, you can now start Dropbox simply by
running

{% highlight bash %}
start dropbox
{% endhighlight %}

and your files will begin synchronizing.

These instructions can be modified fairly easily to be run as a normal
(non-sandboxed) user, or even to handle multiple accounts by multiple
users on the same system: create the `dropbox` user and group with

{% highlight bash %}
useradd -r -d /usr/local/dropbox -U -s /bin/false dropbox
{% endhighlight %}

and skip the `chown` and `chmod` lines and the commands as the
`dropbox` user (everything that references `/etc/dropbox`, basically);
remove the lines from `env HOME=/etc/dropbox` to the first `end script`
(lines 11-18) from the Upstart script; and run `dropboxd` as each user
to link their account and download the files into their home folder.
You can also have the Dropbox files themselves stored in a different
location, either `mount`ed (`bind` if it's a folder, or as a regular
filesystem) or symlinked to `/etc/dropbox/Dropbox`, as long as that
location and the files files themselves are still owned and writable by
Dropbox (make sure to `stop dropbox` BEFORE moving the Dropbox
folder!); if you use a symlink, you can then make that location
readable or writable to any user, or to the `dropbox` group and then
add users to that group to give them access.

Again, I've put together a
[script that runs though the basic process][setup]; feel free to use
and modify that, or go through this process step by step making
whatever adjustments will work best for your own setup. Post your
findings and any questions you may have in the comments.

[^MiB]: Yes, I insist on using binary prefixes. "Mega" as in
    "[megabyte][mb]" (MB) is $$ 10^{6} $$; "mebi" as in
    "[mebibyte][mib]" (MiB) is $$ 2^{20} $$.

[fdra]:  http://fedoraproject.org/
[php]:   http://php.net/
[boinc]: http://boinc.berkeley.edu/
[ubsrv]: http://www.ubuntu.com/business/server/overview
[xmsn]:  http://www.transmissionbt.com/
[httpd]: http://httpd.apache.org/
[mysql]: http://www.mysql.com/
[afp]:   http://en.wikipedia.org/wiki/Apple_Filing_Protocol
[afp2]:  http://missingreadme.wordpress.com/2010/05/08/how-to-set-up-afp-filesharing-on-ubuntu/
[natlk]: http://netatalk.sourceforge.net/
[he]:    http://tunnelbroker.net/
[radvd]: http://www.litech.org/radvd/
[db-gi]: http://wiki.dropbox.com/TipsAndTricks/TextBasedLinuxInstall
[db-us]: http://wiki.dropbox.com/TipsAndTricks/UbuntuServerInstall
[setup]: https://gist.github.com/986199#file_dropbox_setup.sh
[upst]:  http://upstart.ubuntu.com/
[mb]:    http://en.wikipedia.org/wiki/Megabyte
[mib]:   http://en.wikipedia.org/wiki/Mebibyte
