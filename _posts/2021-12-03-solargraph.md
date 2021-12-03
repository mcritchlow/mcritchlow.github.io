---
layout: post
title:  "Using Solargraph LSP with docker-compose"
---
The [Solargraph][solargraph] language server is fairly straightforward to setup
and install, unless of course you want to do it within a container.

Currently, Neovim only supports operating with an LSP via `stdio`, which
thankfully Solargraph supports. Hopefully in the future it will also support
TCP/external server setup.

In order to get this working with a fairly small, simple Ruby project using
`docker-compose`, I first created a little script to install and do initial
setup for `solargraph` in the container, which takes one argument, the name of
the compose `service`. This can be `web`, `app`, etc.

{% highlight shell %}
service_name="$1"
shift
echo "Installing solargraph LSP in application container..."
docker-compose exec "$service_name" gem install solargraph
docker-compose exec "$service_name" solargraph download-core
docker-compose exec "$service_name" solargraph bundle
docker-compose exec "$service_name" yard gems
echo "Finished installing solargraph LSP in application container..."
{% endhighlight %}

Note that this MUST be run prior to opening up Neovim (or your editor of choice)
to ensure all the solargraph bits are installed.

If a team were to agree to adopt solargraph for the project, then this script
could be replaced with adding `solargraph` to the `development` group in a
project `Gemfile`. Then the other parts could probably be placed in a `rake`
task, or something like that. For my purposes, this was an experiment so I kept
this script external to the repository and/or `.gitignore`'d.

Then, in Neovim, I setup a local `.nvimrc` file with the following setup:

{% highlight lua %}
local nvim_lsp = require('lspconfig')
nvim_lsp.solargraph.setup{
  cmd = { "docker-compose", "exec", "-T", "app", "solargraph", "stdio" },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    solargraph = {
      diagnostics = false
    }
  }
}
{% endhighlight %}

The key here is the `cmd` being updated to use `docker-compose` with the `-T`
flag which sets up a TTY for stdio. This setting _should_ exist as an option no
matter how your editor handles LSP configuration.

Perhaps also worth noting is that I'm disabling diagnostics. I previously setup
diagnostics for the projects using [null-ls][null-ls]

So the remainder of my local `.nvimrc` file is as follows:

{% highlight lua %}
-- Null-ls configuration
local null_ls = require("null-ls")

local null_ls_sources = {
  null_ls.builtins.diagnostics.standardrb.with({
    command = "docker-compose-exec",
    args = { "app","standardrb"," --no-fix", "-f", "json", "--stdin", "$FILENAME" },
  }),
  null_ls.builtins.formatting.standardrb.with({
    command = "docker-compose-exec",
    args = { "app","standardrb"," --fix", "--format", "quiet", "--stderr", "--stdin", "$FILENAME" },
  }),
}
null_ls.register(null_ls_sources)
{% endhighlight %}

[null-ls]: https://github.com/jose-elias-alvarez/null-ls.nvim/
[solargraph]: https://solargraph.org/
