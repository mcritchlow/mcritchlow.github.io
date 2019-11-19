---
layout: post
title: "Docker container with a bind mount"
date: 2019-11-19 10:27:11 -0700
---
A quick post that I've found helpful when I need to quickly run a command in a
container, but have resulting files that are created or updated be reflected on
my host machine.

A classic example, is that I need to update a `Gemfile` in a ruby project, along
with its `Gemfile.lock`.

Assuming a built container image called: `my_app`, which has an app stored in
the container at `/home/my_app/app`

```
docker run --rm -it --mount type=bind,source="$(pwd)",target=/home/my_app/app my_app bundle install
```

Will run `bundle install` in the one-off container, and the resulting
`Gemfile.lock` will be updated on my host machine.

This takes advantage of the docker `--mount` option, with more details on the
[documentation page][docker-mount]

[docker-mount]: https://docs.docker.com/storage/bind-mounts/#start-a-container-with-a-bind-mount
