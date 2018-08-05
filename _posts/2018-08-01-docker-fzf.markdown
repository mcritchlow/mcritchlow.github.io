---
layout: post
title:  "Docker bash functions with fzf"
date:   2018-08-01
categories: software docker bash fzf
---

## Introduction ##
Now that our dev team is starting to dip our toes into Docker, I've realized
some pain points with managing docker images and containers that I've solved
with a couple very simple bash functions, utilizing the [fzf fuzzy finder][fzf]
that I have incorporated into much of my daily workflow both in terminal and
vim.

In order to take advantage of these little bash functions, you'll need to install
fzf via the link above, if you don't already have it.

## Problem ##
The problem we're trying to solve with these methods is the following:
> I want to find and remove a specific container or image, without having to
> copy and paste the ID manually

## Bash Functions ##
The simple functions are as follows. Place them in your personal `bashrc`,
`bash_profile` or zsh equivalent. Obviously if these functions somehow conflict
with existing aliases/binaries on your PATH, adjust as needed.

{% highlight shell %}
# drcv [FUZZY PATTERN] - Choose a docker container to remove (and associated volumes)
drcv() {
  docker ps -a | fzf -m | awk '{print $1}' | xargs docker rm -v
}

# drc [FUZZY PATTERN] - Choose a docker container to remove
drc() {
  docker ps -a | fzf -m | awk '{print $1}' | xargs docker rm
}

# dri [FUZZY PATTERN] - Choose a docker image to remove
dri() {
  docker images | fzf -m | awk '{print $3}' | xargs docker rmi
}

# drv [FUZZY PATTERN] - Choose a docker volume to remove
drv() {
  docker volume ls | fzf -m | awk '{print $2}' | xargs docker volume rm
}

{% endhighlight %}

## Big Hammer ##
Want to start completely clean? Create an alias that leverages the relatively
recent `docker system prune` command. I have the following alias setup, and try
to rarely use it.. This removes everything, including attached volumes.

{% highlight shell %}
alias docker-nuke='docker system prune -f --all --volumes'
{% endhighlight %}

## Usage ##
In your terminal, simply type either `drc` or `dri` and hit Enter. You'll be
prompted for a list of either containers or images, type or navigate to the
entry you want to delete and hit Enter.

[fzf]:https://github.com/junegunn/fzf
