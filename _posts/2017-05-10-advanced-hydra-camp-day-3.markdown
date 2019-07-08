---
layout: post
title:  "Advanced Hydra Camp - Day 3"
date:   2017-05-10 18:39:30 -0700
---
Hydra Camp Day 3 followed the same pattern as Day 2 by starting with everyone breaking into groups of 4-6 and
discussing four questions together:

1. What was biggest Aha moment?
2. What slowed you down the most?
3. What were we hoping to learn from today's discussion?
4. How does this fit into your future work?

A general sense was that despite not being fully baked into Hyrax yet, the
ability to integrate IIIF into a Hyrax application is actually quite do-able
today. There's still lingering questions about production configuration and
performance, at least on my end, but overall it was a great session.

Most folks seemed very interested in the workflow lesson for the day. Our group
consisted of some folks from Northwestern and UCSB, and we all had a sigh/laugh
at Northwestern's need for a 53 step workflow. More sighing than laughing,
actually, because we all have similar 'needs'.

Another tidbit I heard from the Northwestern folks is that they're already
working towards porting some of Avalon's A/V features into the Hydra core, such
as hydra-derivatives. Exciting stuff!

### Workflow
We then jumped into Workflow. Some references:
1. [Workflow Lesson][workflow-lesson]
2. [Diagram of one-step mediated workflow][mediated-diagram] from DCE
3. [Workflow and mediated deposit documentation][mediated-docs] which Bess
   started
4. [Workflow validation][workflow-validation] against the schema
5. [Princeton's Book Workflow][book-workflow] with a variety of custom states

Justin walked us through the history of how workflows found their way into
Hyrax, and then we did a walkthrough of the workflow JSON files, how they're
validated, and then we went through a number of the issues with roles,
notifications, and triggered classes. Much of this was a walk-through in the
rails console. And I thought a few of these commands might be of interest to
others. So here's a small sampling of what we did:

{% highlight shell %}
rails c
AdminSet.first.default_set?
Hyrax::PermissionTemplate.all
Sipity::Workflow.all
Sipity::Workflow.all.pluck(:name)
Sipity::Workflow.reflections.keys
Sipity::Workflow.last.workflow_states
Sipity::Role.count
Sipity::Role.all.pluck(:name)
{% endhighlight %}

Workflow responsibility:
1. intersection between action, role and entity who can perform it
2. ex: Metadata Librarian group is responsible for approving step/state X in the
   workflow.

Entity responsibility:
1. not using (as far as Justin knows)
2. used in Sipity
3. assign someone (or theoretically some group?) to an object to approve it

When adding a new Admin Set, all workflows are loaded. So in the case where
there is two default workflow, and an admin creates a new AdminSet, you'll then
get 4 workflows to choose from. This is so different groups/roles can be
assigned to the same workflow in the context of a different Admin Set.

The following triple is set in Fedora once workflow puts an object in an
active/published state. only use #active and #inactive properties are used:

`ns006: objState http://fedora.info/definitions/1/0/access/ObjState#active`

*WorflowActionService* could be used to run items through a workflow step in batch (auto-add comments!), etc.

Following that, we broke into pairs and worked on creating a custom 2 step
workflow. Essentially having a workflow that does:

`deposit -> metadata review -> final review -> published`

Suprita and I spent a lot of time discussing the workflow, states, whether we
needed certain existing states to hook into our new step, etc. I felt like that
discussion was equally valuable in comparison to when we actually sat down and
wrote the workflow JSON file and related code. A definite takeaway was that
custom workflows are very possible, and I could see UCSD having a 2 step
workflow. Though honestly I think we'd be perfectly well off with the existing,
bundled, 1 step workflow.

### Jobs/Actors
1. [Jobs Lesson][jobs-lesson]

After lunch Adam gave us a walk-through of Jobs and how they're implemented in
Hyrax. We ran through setting up resque to process queues. I thought this choice
was a little odd, since the community seems to have moved towards recommending
Sidekiq lately. But, the difference as far as setup between the two is pretty
negligible.

A nice point Adam made was using the redis-cli to inspect the current state of
the queues.

{% highlight shell %}
$ redis-cli
> keys *
{% endhighlight %}

We then walked through the actor stack of jobs, and tried to add a locally
overridden characterization job. A few things that stood out:

1. Overriding a job means a complete replacement.
2. The Characterization and Create Derivative jobs both run indexing tasks. I
   can see this making good sense in the case where only a few source files are
involved. But for a large batch ingest, this seems like a lot of unwanted
indexing in Solr. Perhaps the jobs could be either overridden and updated to run
an indexing task at the end. Or, maybe soft commits.


![Group Picture]({{ site.url }}/assets/group.jpg)
Photo By: Mark Bussey

[jobs-lesson]: https://github.com/RepoCamp/ahc/wiki/Jobs
[book-workflow]: https://github.com/pulibrary/plum/blob/master/config/workflows/books_workflow.json
[workflow-validation]: https://github.com/projecthydra-labs/hyrax/blob/master/app/services/hyrax/workflow/workflow_schema.rb#L57
[workflow-lesson]: https://github.com/RepoCamp/ahc/wiki/Workflows
[mediated-diagram]: https://docs.google.com/drawings/d/1FcOq-0QD-hDKL8ofGTKXjRayJVtAksRCG15DvjVWXZw/edit
[mediated-docs]: https://github.com/projecthydra/projecthydra.github.io/blob/mediated_deposit/pages/hydra/developer_resources/workflow_and_mediated_deposit.md
