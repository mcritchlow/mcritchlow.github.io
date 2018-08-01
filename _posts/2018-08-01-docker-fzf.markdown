---
layout: post
title:  "Docker bash scripts with fzf"
date:   2018-08-01
categories: software docker bash fzf
---

## Introduction ##
Now that our dev team is starting to dip our toes into Docker, I've realized
some pain points with managing docker images and containers that I've solved
with a couple very simple bash scripts, utilizing the [fzf fuzzy finder][fzf]
that I have incorporated into much of my daily workflow both in terminal and
vim.

In order to take advantage of these little bash scripts, you'll need to install
fzf via the link above, if you don't already have it.

## Problem ##
The problem we're trying to solve with these methods is the following:
> I want to find and remove a specific container or image, without having to
> copy and paste the ID manually

## Bash Functions ##
The simple functions are as follows. Place them in your personal `bashrc`,
`bash_profile` or zsh equivalent.

{% highlight shell %}
# drc [FUZZY PATTERN] - Choose a docker container to remove
drc() {
  local container_id
  container_id=$(docker ps -a | fzf | awk '{print $1}')
  docker rm "$container_id"
}

# dri [FUZZY PATTERN] - Choose a docker image to remove
dri() {
  local image_id
  image_id=$(docker images | fzf | awk '{print $3}')
  docker rmi "$image_id"
}
{% endhighlight %}

## Usage ##
In your terminal, simply type either `drc` or `dri` and hit Enter. You'll be
prompted for a list of either containers or images, type or navigate to the
entry you want to delete and hit Enter.

[fzf]:https://github.com/junegunn/fzf