---
layout: post
title: Simple PHP IPv6 Detection Script
published: true
tags:
  - code
  - IPv6
  - jQuery
  - PHP
---

This is a simple [PHP][] script I wrote for detecting whether a visitor
to a page is connected via IPv4 or IPv6, matching the remote address
server variable or an address passed as a query parameter to a regular
expression and returning the address and protocol as [JSON][].

{% gist 986186 v6.php %}
<!-- more -->

I found the IPv6 regular expression through a Google search; and yes, I
know it doesn't check to see if the address is valid. No need for that,
I say, when it'll mostly be using server-side values for the visitor's
address. A basic implementation using [jQuery][] (replacing, of course,
the URL of the script with wherever you choose to host it) would look
something like this:

{% gist 986186 v6_ajax.js %}

A `<span id="remote_ip" />` or `<div id="remote_ip" />` (remember the 
closing `/`, or closing tag to stay HTML5-valid) would be replaced with

    Connected via IPv6 from 2000:4000:aaa:22bb::dead:b33f

so that a visitor can see what protocol and address they're connected 
with. You can also use the script to track how many visitors to your 
site use IPv6. It may be trivial, but it's just something I threw 
together on a whim because I felt like it and thought it'd be a fun 
exercise in regular expressions, JSON, and jQuery.

[PHP]: http://php.net/
[JSON]: http://www.json.org/
[jQuery]: http://jquery.com/
