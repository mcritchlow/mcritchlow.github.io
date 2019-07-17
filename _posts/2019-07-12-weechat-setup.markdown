---
layout: post
title:  "Setting up weechat with wee-slack"
date:   2019-07-12
---

Install `weechat` and `wee-slack`

Install scripts:
```
/scripts
- autojoinem
- autosort
- colorize_nick
- go
- urlserver
```

Setup some basic configuration:
```
# or whatever to make the buffer list reasonable
/set weechat.bar.buflist.size 30
# fix urlserver plugin port
/set plugins.var.python.urlserver.http_port "60211"
# set slack download location
/set plugins.var.python.slack.files_download_location = "~/Downloads/"
# yes.. emoji
/set weechat.completion.default_template "%(nicks)|%(irc_channels)|%(emoji)"
```

References:
- https://weechat.org/files/doc/stable/weechat_quickstart.en.html#irc_server_options
- https://www.bfoliver.com/technology/2017/07/15/weechat/
- https://github.com/wee-slack/wee-slack
- https://wiki.archlinux.org/index.php/WeeChat
