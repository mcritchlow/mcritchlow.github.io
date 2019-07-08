---
layout: post
title:  "Using vim-test with docker-compose"
date:   2019-04-10
---

A short one, but this has been really helpful. We've primarily migrated to using
container-based development environments at work, which has been great in many
respects. For example, for our oldest ruby legacy application I no longer have
to do a [custom openssl-1.0 installation][ssl-hell] to get Ruby 2.3.7 installed
locally. I can run it in a container!

The downside is, a local development environment usually keys off of things
being local as an assumption. I ran into this using the [vim-test][vim-test]
plugin in Vim, which I love.

The default prefix for ruby projects with `rspec` doesn't work when I need the
tests to run in a (for this example) docker-compose context. The solution? A
custom vimrc project file (.gitignored), and a custom setting for the ruby
`spec` executable in vim-test.


Example local project `vimrc.local`:

```
let test#ruby#rspec#executable = 'docker-compose -f "./docker/dev/docker-compose.yml" exec web bundle exec rspec'
```

Now, my normal mode mappings for doing quick test validation work again. Yay!

[vim-test]:https://github.com/janko/vim-test
[ssl-hell]:https://wiki.archlinux.org/index.php/Rbenv#Ruby_2.3.x


