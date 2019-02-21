---
layout: post
title:  "Ruby Spelunking"
date:   2019-02-21
categories: software ruby debugging
---

> or "where the f^&$ is that method defined?!"

This is a short one, but inspired by a recent RubyTapas video.

I've started exploring the capabilities of Pry more to help when ctags or other
methods aren't sufficient for easily navigating to a method and answering
questions like:

- Where is it defined? By Who?
- What is the source code of that method? (is it something I can hook into,
  patch, etc.)

It turns out, Pry does this beautifully.

What is the source of a method? Use `.source.display` on the  method

```
[11] pry(main)> Spotlight::Resources::Upload.instance_method(:build_upload).source.display
        def build_#{name}(*args, &block)
          association(:#{name}).build(*args, &block)
        end
=> nil
```

Where is that method defined? Use `.source_location` on the method

```
[12] pry(main)> Spotlight::Resources::Upload.instance_method(:build_upload).source_location
=> ["/home/mcritchlow/.rbenv/versions/2.5.3/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6.1/lib/active_record/associations/builder/singular_association.rb", 26]
+[13] pry(main)>
```
