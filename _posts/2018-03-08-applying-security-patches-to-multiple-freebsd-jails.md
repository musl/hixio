---
layout: post
published: true
title: Applying security patches to multiple FreeBSD Jails
date: 2018-03-08T10:00:17-08:00
---

Up until FreeBSD 10.3, `freebsd-update` could not be run
non-interactively. This means you couldn't run it from a shell script
without hijinx or from a loop on your shell when you wanted to update
multiple jails. Here's what you'd see:

		freebsd-update fetch should not be run non-interactively.
		Run freebsd-update cron instead.

After 10.3-RELEASE, `--not-running-from-cron` was added allowing
something like this:

		jls | awk '!/JID/ {print $3}' | awk -F '.' '{print $1}' | sort | while read j
		do
			PAGER=cat freebsd-update -b /jails/$j/root --not-running-from-cron fetch install
		done

The above retrieves the names of all running jails, trims off the short
host name, and for each, applies security updates to each jail in turn.

This could be cleaned up with a script and something that can query
FreeBSD directly for jail definitions, but for now it's working for me.

