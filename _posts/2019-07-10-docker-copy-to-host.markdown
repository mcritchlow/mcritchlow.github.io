---
layout: post
title:  "Copying files from container to host"
date:   2019-07-10
---

Another short one, also container related. In order to completely avoid the need
to have local versions of Ruby, bundler, etc. installed for an application,
there are times when you need to copy a file that was added or modified within
the container back to the host. This is rare, but has happened a few times to
me. Often with an updated `Gemfile.lock`

Here's a nice docker copy command for doing that:

```
docker cp <containerId>:/file/path/within/container /host/path/target
```

Example:

```
docker cp dev_web_1:/usr/src/app/Gemfile.lock ./Gemfile.lock
```
