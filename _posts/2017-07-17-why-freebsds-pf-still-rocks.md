---
layout: post
published: true
title: Why FreeBSD's pf Still Rocks
date: 2017-07-18T07:05:39-07:00
---
Over the years, I've found few pieces of software that just function as
advertised, are trustworthy, or that live up to their stated purpose.
Gracing that list of trustworthy, stable, and useful stuff are titles
like pf, postgres, and vim. No piece of software is perfect. Even in
those three examples there are three potential flame wars.

Since this post isn't about shaming developers or complaining about some
bug, let me get to the point: FreeBSD's pf rocks. Yep, it's more or less
a fork of OpenBSD's pf. Yes, it doesn't run on Linux. I'm not going to
complain about iptables or do too much comparison of the two tools.
They're designed differently; it's completely in your power to learn
about both.

If you know any BSD you're not using it to help protect your home router
or possibly for your small-to-medium business you probably should be.

Here's why:
- configuration & rule sets
  - one well-organized file
  - variables and tables to help DRY things up
  - simple evaluation control
- performance
  - rock solid
  - operates deterministically
  - can be updated while preserving connection state
  - easy to inspect the current running rule set
  - reasonable rule sets have nearly no impact on throughput, even on
  embedded platforms.

Now, the caveat is with most things in tech is the learning curve. It's
no different here.  Fantastic docs abound, but it can be an effort to
distill things down into a pragmatic, useable set of ideas. As much as I
want to, I'm not going to do that here.  Maybe in a future post.

## Configuration & Rule Sets

PF has a configuration language. For the most part it's broken English
with jargon and templating. It is well organized within configuration
file which is usually at `/etc/pf.conf`.

The configuration file is organized into sections, carefully detailed in
the `man` page: Macros, Tables, Options, Traffic Normalization, Queueing,
Translation, and Packet Filtering. Not only does this organize the file,
but it makes things easier to reason about. The way the packets are
modified and handled basically matches what's in the file.

Variables and tables are available. This means that you don't need to
rely on bash or some other language to handle that problem. It also
means that changes in interfaces or rule sets take less work.

``` shell
# Interface names so you only have to declare them once.
if_wan = igb1
if_lan = igb2

# A table so that rules are easy to work with.
table <martians> const { \
        0.0.0.0/8 \
        10.0.0.0/8 \
        127.0.0.0/8 \
        172.16.0.0/12 \
        192.168.0.0/16 \
        169.254.0.0/16 \
        192.0.2.0/24 \
        240.0.0.0/4 \
}

# Here's an example of using both interface variables and tables.
block quick on $if_wan from <martians> to any label "martians"
```

Here's how you test your rule set before applying it:

``` shell
$ pfctl -vnf /etc/pf.conf
``` 

Apply it without interrupting open connections that aren't now blocked
by new rules - by dropping the `-n`. Amazing.

## Summary

I've run pf in production and at home for at least seven
years. Anecdotally, it's one of the most stable pieces of software
I've ever used. For medium and small offices with tens to hundreds of
users, two pf boxes and carp can provide more than adequate throughput,
availability, and resilience.

