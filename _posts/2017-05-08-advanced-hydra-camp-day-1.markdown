---
layout: post
title:  "Advanced Hydra Camp - Day 1"
date:   2017-05-08 18:39:30 -0700
categories: hydra development
---
Today was the first day of they inaugural Advanced Hydra Camp. The purpose of the
camp is to do a deeper dive into the Hydra stack as it stands today. That means
primarily Hyrax development, PCDM data modeling, IIIF, and Fedora 4. While Hydra
Camp offers a developer an excellent introduction to getting up to speed on the
basics of Hydra, this camp offers a bit more depth. To this end, as far as the
first day is concerned, this proved to be true.

The day began with an overview, by Adam Wead, of "how we got here". It went
through the history of the various parts of Hydra over the last several years,
and led up to the merger of Sufia and Curation concerns that spawned Hyrax. I
actually think at least some version of this [Hydra history][hydra-history]should be required reading (ok
maybe that's a bit strong) for folks entering Hydra-land.

After that we went into the latter half of the documentation which covered the
[Anatomy of the Hyrax Stack][hyrax-anatomy]. Given the recent architectural
changes, and the introduction of patterns such as Presenters, Renderers, and
Actors, I think this documentation is incredibly valuable. Many of us in the
room immediately came to this same conclusion. Excellent stuff. One question I
did ask, which triggered an interesting discussion, was about validations and
where they belonged in a Hyrax stack. While mostly on the front end, Justin
Coyne also noted there are some example of validation in the Actor stack and
Anna Headley found an example in the [Optimistic Lock
Validator][lock-validator]. There seemed to be an interest at least between a
few of us to discuss this further, and there might end up being a longer
discussion or breakout to do that later in the class.

Also worth noting, is Adam Wead pointed us to a collection of [rspec
templates][rspec-templates] that he used for a presentation he did for, I
believe, the last Hydra Connect. This is a great reference that I've bookmarked
to circle back to when writing new tests for various parts of our Hydra app.

### Pairing - MusicalWork
For the majority of the rest of the day, we broke into pairs and did some
pairing on adding new properties to a MusicalWork model, getting them connected properly to a
presenter, getting the presenter correctly wired into the proper controller,
getting the properties delegated from the presenter to the SolrDocument class,
and pulling that data from Solr. One takeaway I had was there are actually two
different ways of getting the data from solr in the SolrDocument class than the
method we're using in our app.

Currently, our Solr Document would have a method like the following:

{% highlight ruby %}
def creator
  return [] if self[Solrizer.solr_name('creator')].nil?
  self[Solrizer.solr_name('creator')]
end
{% endhighlight %}

A newer variation that uses the #fetch method in SolrDocument simplifies the
method to:

{% highlight ruby %}
def creator
  fetch(Solrizer.solr_name('creator'), [])
end
{% endhighlight %}

But, it appears there's a new kid on the block, that removes the need for an
explicit method declaration, instead leveraging the new #attribute
implementation defined in [Hyrax::SolrDocument:Metadata][hyrax-attribute]. This allows a property to be defined in the SolrDocument as:

{% highlight ruby %}
  attribute :creator, Solr::Array, 'creator_tesim'
{% endhighlight %}

Tom Johnson also called out a neat trick when we were talking about defining
RDF::URI's. He said that instead of RDF::URI.new or RDF::URI(), one could do:

{% highlight ruby %}
  ::RDF::URI.intern('http://permanent.link#is-a-lie') 
{% endhighlight %}

This apparently adds the URI to an in memory cache, which, given that one is
likely to use this URI in tens of not potentially thousands of records, could
come in quite handy.

### PCDM Intro
Finally, Tom went through an overview an initial dive into PCDM and how it's
implemented in Hydra. He also gave a brief summary of the role of ActiveFedora,
which I think for folks who even have some familiarity with Hydra, but less
expierence with that part of the stack. Essentially, he noted ActiveFedora plays
two roles:

1. Talks to ActiveTriples. Provides metadata editing and querying. It
   handles the metadata in memory in a graph GeneratedResourceSchema. There's a
little bit of meta-programming happening when the [schema][resource-schema] gets
attached to a class, but it's actually pretty well documented.
2. Talks to LDP. Ultimately, it sends the graph stored in the
   GeneratedResourceSchema to Fedora.

Tomorrow we're going to get into adding a new Cover 'work' and allowing our
existing MusicalWork model to have 0-m covers.

Finally, Bess Sadler mentioned a book in class called [Joy, Inc.][joy-book] which DCE all
recently read together. It sounds like it touches on a lot of things that I've
been thinking about lately, so I've added it to me reading list.

[hydra-history]: https://github.com/RepoCamp/ahc/wiki/Hyrax-Introduction
[hyrax-anatomy]: https://github.com/RepoCamp/ahc/wiki/Hyrax-Introduction#anatomy-of-a-hyrax-stack
[lock-validator]: https://github.com/projecthydra-labs/hyrax/blob/master/app/actors/hyrax/actors/optimistic_lock_validator.rb
[rspec-templates]: https://github.com/awead/hydra-rspec-templates
[hyrax-attribute]: https://github.com/projecthydra-labs/hyrax/blob/master/app/models/concerns/hyrax/solr_document/metadata.rb#L6-L10
[resource-schema]: https://github.com/projecthydra/active_fedora/blob/master/lib/active_fedora/fedora_attributes.rb#L54-L69
[joy-book]: https://www.menloinnovations.com/joyinc/
