---
layout: post
title:  "On leaving macOS for Linux"
date:   2017-05-30 18:39:30 -0700
categories: linux macos solus development
---
### Background
I'm going through a job transition that I intend to write a separate post about. The only relevant detail is that this
upcoming change caused me to take one of those healthy steps back and look at what my day-to-day workstation setup is,
what I like about it, what I don't, and whether there are alternatives I should be taking a look at.

I've been using macOS in my current job essentially since we transitioned to Ruby development. For Java development,
Windows always worked pretty well. For Ruby, particularly several years ago, it was painful at best and impossible at
worst. Some of the reason why Ruby has historically worked so poorly on Windows has recently explained by Avdi Grimm
and, for those interested, I highly recommend reading his [Ruby Code on Windows][ruby-windows] post.

In any event, I started thinking about what I liked and disliked about the macOS environment I was in. Some of that
thought process is below:

Pros:
* Familiar - Entire team uses, most of ~~Hydra~~ Samvera community uses. Go to any conference, it's a sea of Macbooks.
* [Homebrew][homebrew] - I think Apple should be very, very thankful that Homebrew is a thing, or they'd have lost the developer
  community a long time ago)
* Cohesive. Hardware + OS are specifically setup and configured for one another. Includes as lot of other software as
  well. It 'just works'.
* Have all productivity apps I'd need from the Windows side. MS Office, Exchange/Outlook, Slack, Zoom, etc.

Cons:
* Ecosystem. I am not an Apple-person. I don't have any other iDevices, so the integrated ecosystem is not of any value
  for me.
* Increased move towards convergence/integration. macOS is getting more iOS-y. For many, I think that's a huge benefit,
  again if you're in the ecosystem with multiple Apple devices. I'm not. I don't need Siri on my laptop.
* Apple ID. I'm increasingly annoyed that I need to have an account with Apple to download basic software, often that
  has nothing to do with them.

This exercise left me with the decision that I wanted to get out of the iBubble and look around again. The obvious
candidates were Windows 10 and Linux. Without going into all the details of why, I will say I chose Linux for a few
primary reasons:

* Our app servers are all running Linux (RHEL or Ubuntu) and I want increased familiarity with Linux in general. Running
  it on the desktop seemed like a great excuse for that. I want to get my hands dirty, so to speak.
* Linux doesn't suck anymore on the desktop. Yes, it used to, but if it's been years since you've looked I'd encourage
  you to look again. There are still some issues on the edges (I'll write about mine), but in my opinion the minor
annoyances are well worth the payoff.
* Free software. This increasingly means a great deal to me. Not that it ever didn't, but suffice to say I have a more
  mature perspective on this now, and while it's not absolute (I can't hang with Stallman), I greatly value free
software and I role I think it needs to increasingly play in our increasingly integrated and less private world.

### Testing
Next was choosing a Linux distribution and desktop environment. This is a "problem" that Apple and Microsoft users don't
have to concern themselves with. You're either running Windows 10, or you're not.

With Linux, there are many, many, distributions and on top of that there are many, many desktop environments. And many
desktop environments, such as GNOME or KDE, can be installed on most distributions. So it's quite a decision making
process.

For distributions, I settled on testing the following:
* Ubuntu
* OpenSuse (Tumbleweed)
* Elementary OS
* Solus

For desktop environments:
* Unity (Ubuntu default)
* GNOME 3.24 (OpenSuse)
* Pantheon (Elementary)
* Budgie (Solus)
* Mate (Ubuntu)
* i3 (Solus) - yes I know it's not a DE but a window manager ;)

I setup a whole host of VM's on my macbook for testing this out. My key takeaways (for me):
* LTS is just not for me. I found the underlying packages available in Ubuntu and Elementary by extension, were just way
  outdated. Yes I can build from source, yes I could use 3rd-party PPA's, but it just didn't sit right with me for a
developer-focused environment.
* Unity is horrible. I just can't.
* Elementary is beautiful, they do so many things right. Particularly with HiDPI support, accessibility, integration
  with their apps, etc. If this didn't have the underlying Ubuntu dependencies and release cycle, I'd be very, very
tempted to run this everyday. Their [new app store][elementary-store] is amazing too. I think this is a model for supporting free software
applications that needs to be taken seriously and rolled out elsewhere.
* OpenSuse Tumbleweed is really under the radar, at least as far as I can tell. It's a true rolling, automated,
  distribution but it has an amazing amount of automated testing build into it. So it's unlike a typical 'dev' branch of
a distribution that is often totally broken. It's completely viable as a daily driver, in my opinion. It's pretty incredible, actually. If Solus ever
dissolves, it would be Tumbleweed + GNOME/i3 for me without a doubt.
* Solus. I came to Solus late, kind of stumbled upon it. I saw [Brian Lunduke's interview][lunduke] with Daniel from Elementary,
  Martin from Ubuntu Mate, and Ikey from Solus and was immediately curious by how I heard Ikey describe Solus and what
it's trying to be and accomplish.
* i3. This is so interesting and.. fun! I'm not running it now, primarily because of some HiDPI issues I don't have the patience
  to look into at the moment, and also because I happen to love Budgie. But i3 is an amazing, no BS, environment for getting stuff
done. Particularly for people who prefer to navigate with a keyboard, which I do.

After trying out all the variations. I kept coming back to Tumbleweed+GNOME and Solus. In some ways it was a toss up. In
the end, I preferred Budgie to GNOME, and I like the direction Solus is going. The decision to target the OS
specifically for x86 64 bit devices and to not also be a solution for a server, leaves a lot of potential historical
'baggage' out of this OS. Ikey also works for Intel on the Clear Linux project, and so it's safe to say there's some
positive overlap with support for things like the [CLR Boot Manager][boot]. The only other main positive I'd note about
Solus is how well integrated nvidia drivers are, including support for Optimus. On Tumbleweed, since it moves SO fast
and they don't include the drivers by default, kernel updates means rebuilding drivers. Solus chooses to handle that for
users.

### The install..
Mostly a breeze. Burned the ISO I'd been using with the VM to a USB stick using Etcher. Booted the laptop, did the F12 dance,
and the installation process was very simple. My laptop is setup with full disk encryption via LUKS, which was simple to
configure in the installer and has worked brilliantly. The laptop also has an nvidia card, and was instantly recognized
and the correct driver was able to be installed. I tried using the Linux Nouveau driver for a while, but had issues with
Zoom and a few others things. So, yeah, it's the proprietary driver for now..

Ok, so here's the downside. The damn touchpad doesn't work. Not "oh this fancy five finger pinch gesture" doesn't work.
The entire thing doesn't work and is recognized as a PS/2 mouse by the kernel. After some research, I came to sadly find
that this is a pattern with Dell laptops, particularly ones that use ALPS touchpads. I really wish I would have known
this before, sigh. In any event, I've gotten even better with keyboard shortcuts, and am making due with a USB mouse for
when I really need it. And I've filed a kernel bug, which will hopefully be resolved soon. Good times.

### After a few weeks
Solus is rock solid. I've already done several kernel updates, Solus is currently on the 4.9 LTS series, which includes
nvidia drivers and other packages. Everything has been fantastic. And Solus is fast, like unbelievably fast. Boot times and
shutdown times are almost instantaneous. This is admittedly on new hardware, but I experience similar speed even on the
VM with much fewer resources and have read similar accounts of others.

I've submitted and updated a few packages. I would call the Solus package management process a mix of a rolling release
and curation. There's a code review cycle similar to what I'm used to with software development on Github and pull
requests. And I will say if Github ever starts throwing ads into my PR's and goes the way of Twitter/Instagram/Facebook,
I would pretty happily switch over to [Phabricator][phab] which Solus is using. It's excellent.

The new laptop came with a HiDPI screen. Solus recognized and handled this perfectly. None of the typical tweaking was
necessary on my part, it was handled. The only exception was Zoom, since I had to build it. But I knew this was coming.
Where I really ran into HiDPI issues was trying to log into i3 on Solus. While i3 itself supports HiDPI and the
windowing interface was scaled on login, none of the applications were scaled. I've played around a little with this,
but no changes I've made have made any difference. And I'm plenty happy with Budgie to not spend more time on it at the
moment.

My ongoing concerns are HiDPI related though. Budgie, like most desktop environments, is using Xorg, and Xorg has a single DPI setting it shares with
everything. So, for example, plugging into a 720 or 1080 monitor is likely going to require some creativity on my part.
I've read some nice examples in the [Arch wiki][arch-wiki] on how to do this with `xrandr`. But I haven't had the need yet. We'll see.. I hope
Wayland is solid and stable enough for use in Budgie 11, which will be built on Qt instead of GTK incidentally, and that this issue becomes a thing of the past.

My damn touchpad still doesn't work. Sadly I can only blame this on Dell and ALPS, and myself for not having come across
this pattern earlier for new Dell laptops. Fortunately someone from ALPS seems to be responsive to my bug report and
looking into a fix.

Overall, I'm really happy with the change and feel confident with it. I don't miss macOS at all :)

[arch-wiki]: https://wiki.archlinux.org/index.php/HiDPI
[homebrew]: https://brew.sh/
[phab]: https://www.phacility.com/
[boot]: https://github.com/clearlinux/clr-boot-manager
[lunduke]: https://www.youtube.com/watch?v=OgBQ1tOvFcI
[ruby-windows]: https://www.rubytapas.com/2016/12/14/ruby-code-on-windows/
[elementary-store]: https://www.rubytapas.com/2016/12/14/ruby-code-on-windows/
