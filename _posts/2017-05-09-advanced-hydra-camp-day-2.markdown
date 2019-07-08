---
layout: post
title:  "Advanced Hydra Camp - Day 2"
date:   2017-05-09 18:39:30 -0700
---
Hydra Camp Day 2 kicked off with everyone breaking into groups of 4-6 and
discussing four questions together:

1. What was biggest Aha moment?
2. What slowed you down the most?
3. What were we hoping to learn from today's PCDM discussion?
4. How does this fit into your future work?

While I won't name any specifics, there was definitely a pattern of appreciation
for the morning architecture review, the experience of pair programming, and a
better understanding of how to wire up the various parts of the new PCDM/Hyrax
framework. Personally, I think the challenges of the day as far as programming
tasks were a pretty fair reflection of the reality of Hydra development. So I
was all for the (reasonable) chaos. There were, however, times where it was
clear the class or individuals were struggling with something that legitimately
could just be supported better by the framework. I really admired Tom Johnson
taking the time to explicitly state that, essentially, 'if you see something,
say something'.

### PCDM Cont.
After that Tom took us through some PCDM for the first half of the day. But we
kicked off by reviewing some questions that had come up the previous day around
the differences between PCDM and Hydra Works, versioning in Fedora as it stands
today vs the current API discussions, as well as some pointers to the very well
documented RDF.rb library. All this information is available in a [wiki
page][pcdm-wiki]. One thing I found interesting about the Fedora API versioning
discussion, which is targeting [Memento][memento], is the usage of a
[TimeGate][timegate]. It apparently is really well setup to handle the
versioning of existing content, but doesn't actually speak to how one creates
those versions. I'm definitely curious to read more about this. It sounded like
the general goal is to add LDP sugar on Memento so you can use LDP interaction models to manage versions.

Then Mark asked a question referencing back to the previous day about the
difference(s) between an LDP RDF Resource and an non-RDF Resource. My key
takeaways from this were the following:
1. In Fedora-land, non-RDF resources are the things we want to preserve.
2. [http range 14 rule][http-14]: when send get request to thing like Eiffel Tower, supposed
   to send back redirect to thing that’s actual representation. There's logic in
place to give you the best representation based on what you're asking for.
3. Resource = literally anything

One can, with a Hydra PCDM-based app, check out pieces of this by doing the
following in the rails console. This is another thing I'm planning to
experiment with a bit more.

{% highlight shell %}
f = Hydra::PCDM::File.new
f.content = “Moomin”
f.save
f_ldp = f.ldp_source
f_ldp.get
f_ldp.get.body
{% endhighlight %}

We then broke into a pairing session with the following goals:
1. Create a new Work type called Cover
2. Cover should have properties: creator, description, subject
3. Cover should have a Presenter and Form
4. Cover should have Feature and Unit coverage

Most of this was actually reasonably straightforward. However, there were some
interesting things that came up.

1. The properties we added for Cover were already provided by BasicMetadata
   since the generator for a GenericWork automatically includes it in the model.
This caused us to have a discussion about whether it's worth having tests in the
model and/or presenter to explicitly check that those properties exist, can be
get/set, etc. In the moment, I leaned towards having them because I could
imagine a scenario where BasicMetadata changed upstream and suddenly those
properties disappeared. Stranger things have happened.
2. I was also curious about the scenario where one ONLY wanted those three
   properties, which would require either removing BasicMetadata (which caused
explosions in other parts of the code I want to track down and understand) or
removing the terms from places like the Form. I opted for the latter, and that
seemed to work pretty well.

We never actually got to wiring the MusicalWork to the Cover class, but Tom is
going to finish out the branch and so I'll be reviewing this more once I have
that reference.

He did show, right at the end, using a new-ish way of establishing the
relationship. So in the parent MusicalWork model, you would do:

{% highlight ruby %}
has_subresource :my_cover, class_name: "::MusicalWork::Cover”
{% endhighlight %}

[has_subresource][has-subresource] would let you associate existing Covers with a MusicalWork. The way our
Hyrax app currently works follows the alternative ActiveFedora Associations
method of using [NestedAttributes][nested-attributes], following the rails
accepts_nested_attributes_for pattern. This pattern works when you want to have
a single form and construct all the related class instances directly in related
to the parent. I actually suspect we want a mix of both, so I want to look into
the has_subresource thing more. I think this used to be available via #contains,
but I'd have to look back to be sure.

### Open Book Tour
Then we got a tour of the OpenBook building which was amazing. Lots of history
and another example of how supportive the Minnesota community is of the arts and
literature. One of the more amazing things we saw was a hand printing that was
being done of a Midsummer Night's Dream.

![Press]({{ site.url }}/assets/press.jpg)

![Midsummer Night's Dream]({{ site.url }}/assets/book.jpg)


### IIIF
For the rest of the day, Justin Coyne walked us through the IIIF. He had already
setup a great [reference page][iiif-wiki] on the wiki, which I intend to go back
and read more about later. But we covered that there are actually four API's
that comprise the IIIF, and that we would be focusing primarily on the Image and
Presentation API's today.

In short, the Image API is what is used to perform REST-based interactions with
single images. The full API is pretty thorough, arguably too thorough. I mean,
does anyone really need the ability to do 45 degree rotations on images on the
fly? *shrug*.

We then went through an exercise of:
1. Uploading an Image to a Work
2. Moving the Image rendering location in the presenter to the top
3. Adding the 'riiif' gem to our project
4. Mounting the Riiif engine in config/routes.rb
5. Copying a Riiif config from Hyku to our project
6. Copying the _representative_media.html.erb partial from hyrax to our codebase
7. Updating that partial to print out the identifier when it renders an image
8. Using that identifier to play with the IIIF endpoint to generate different
   derivatives.
9. Added the openseadragon JS viewer to the partial. One thing I found odd is
   this is available because of a bundled [Blacklight
Gallery][blacklight-gallery] plugin. It would take some grepping to find this,
and it's not at all obvious. Also, don’t send locale to RIIIF, so we pass
locale: nil to the openseadragon_picture_tag helper.
10. Added an IIIFAuthorization service, copied from Hyku

After a break, we went through the process of manually creating manifests to
support a Work that contains multiple images. A classic example being something
like a MusicalWork, a Book, or a Newspaper. I'm looking forward to migrating our
newspapers and similar content in the future to proper multi-image objects so
they can take advantage of this. Some highlights of this part for me:

1. UniversalViewer is a PITA to package for the Rails asset pipeline. Hopefully
   with Rails 5.1 support for JS changing, maybe this will get better? In the
meantime, the pattern seems to be placing it all in the public/ folder of the
app and having Apache/Nginx serve it.
2. Clean the caches!
3. I'm still unsure about production level performance.
4. Order of images ingested was raised and two points came out.
- Use the File Manager to update order if needed.
- Upload things in a Batch Upload context as unordered, and then apply order once at the end. I believe this was a lesson learned from our friends at Princeton.
5. IIIF support in Hyrax needs more development iterations and institutions
   kicking in to help build in in Hyrax proper.

Another day of wonderful brain drain. I finished it by eating two pizzas.

[http-14]: https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
[blacklight-gallery]: https://github.com/projectblacklight/blacklight-gallery/blob/e7cd4b0a9bb865ccc203a6f5a96e4c611bc3294c/blacklight-gallery.gemspec#L23
[iiif-wiki]: https://github.com/RepoCamp/ahc/wiki/IIIF
[has-subresource]: https://github.com/projecthydra/active_fedora/blob/master/lib/active_fedora/associations.rb#L186-L201
[nested-attributes]: http://www.rubydoc.info/github/projecthydra/active_fedora/ActiveFedora/NestedAttributes/ClassMethods#accepts_nested_attributes_for-instance_method
[timegate]: https://github.com/mementoweb/timegate
[memento]: http://www.mementoweb.org
[pcdm-wiki]: https://github.com/RepoCamp/ahc/wiki/Pair-Session%3A-PCDM-Modeling
