# InElegant – a modified Elegant theme for Pelican

[Elegant] is a theme for the static site generator [Pelican].

[elegant]: https://github.com/Pelican-Elegant/elegant
[pelican]: https://getpelican.com/

[InElegant] is also a theme for the static site generator Pelican.
InElegant is based on Elegant, with some tweaks and fixes for
[my own use].

[inelegant]: https://github.com/obriencj/pelican-inelegant
[my own use]: https://obriencj.preoccupied.net/

pelican-inelegant provides a container which bundles up the Pelican
tool, a selection of plugins, and the InElegant theme.

pelican-inelegant also provides a GitHub Action of the same name which
can be used to trigger the build of a pelican-based site from within a
workflow.


## Pelican InElegant Container

The container produced by this fork is my way of ensuring that the
site which builds today will also build tomorrow. It locks into place
a known-working version of the Pelican tool, plus various plugins and
supporting packages and my forked copy of the theme. It can be run
directly, or utilized via an action to produce a site build.

The container is multi-stage, first focusing on setting up a node
environment to perform the CSS and JS transformations. These results
are then copied into the final container which doesn't need node
installed in order to operate.


## Pelican InElegant GitHub Action

The action produced by this fork provides an easy interface for
invoking the container to rebuild a site for deployment to GitHub
pages

```yaml
jobs:
  build-site:
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Build site
        uses: obriencj/pelican-inelegant@master
```

The github action can be used with any theme, not just InElegant.
However the theme will need to be available in your workflow checkout.
The theme path can be specified in the `pelicanconf.py` or via the
`theme` parameter to the action itself.


## Differences from Elegant

I liked a lot of what Elegant had to offer, but there were a few
things that didn't quite fit with my existing site content as I was
porting from Octopress to Pelican. So of course I had to get in
there and change some stuff! InElegant is my messy attempt to
turn Elegant into what I needed.


### Overall Git Layout

I dropped the documentation blog, and a number of dependency files.

I re-organized the js and css sources that were minified/squished
together to the final js and css so that only the results were
published.

I added a Makefile for setting up the relevant node deps and for
creating a local copy of the container. Gulp is left to only handle
the js/css steps,  though I'd like to eventually drop node entirely.

I forced a number of node components to upgrade, and stripped out
others that could be replaced by something else. This cleared up a
number of dependabot security alerts.


### Basic HTML

There were a few HTML errors in the original Elegant templates which I
have fixed. I'd love to migrate to XHTML 1.0 strict at some point in
the future.

I injected a site content copyright declaration into the html meta
header.


### Basic CSS

There was some fighting over block types for anchors and images that I
found annoying. I also didn't like the floating underline being
produced as a transform/translate. So now images correctly clear and
can be wrapped around with the `float` attribute.

I also tweaked the footer to center the site title, and added a line
break between title and subtitle (since some of mine were way too long
when presented on a single line).


### Pages

I added a Pages header for listing all of the static non-article
pages. I had a lot of them, and the only other option was including
every single one in the navigation bar.


### Code blocks

I disliked the pygments theme that elegant went with, so I swapped
back to the pygments default theme. I also didn't particularly like the
Copy feature, so I ripped that out.


### Additional social links

I added a Strava social link, and will be adding a Threads one
soon(ish). I also limited the display of social links to rows of four.


## License

Elegant is released under the [MIT License]. See their
[`THANKS.md`][thanks] file for a list of contributors.

InElegant is released under the [MIT License] as was Elegant before it.

All code contributions are made directly under the [MIT License] as
well. This is commonly referred to as the "Inbound=Outbound licensing
model", as the license everyone contributes their code under
(i.e. inbound license) is exactly the same as the license that the
code is then being released under to the general public.

[thanks]: https://github.com/Pelican-Elegant/elegant/blob/master/THANKS.md
[mit license]: https://spdx.org/licenses/MIT.html
