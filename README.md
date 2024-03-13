# Inelegant – a modified Elegant theme for Pelican

[Elegant] is a theme for the static site generator [Pelican].

[elegant]: https://github.com/Pelican-Elegant/elegant
[pelican]: https://getpelican.com/

[Inelegant] is also a theme for the static site generator Pelican.
Inelegant is based on Elegant, with some tweaks and fixes for
[my own use].

[inelegant]: https://github.com/obriencj/pelican-inelegant
[my own use]: https://obriencj.preoccupied.net/

The pelican-inelegant container provides a repeatable and reliable way
to rebuild a pelican-base site. It bundles up the Pelican tool, a
selection of plugins, and the Inelegant theme.

The pelican-inelegant [GitHub Action] can be used to easily trigger site
rebuilds from within a workflow.

[github action]: https://docs.github.com/en/actions


## Pelican Inelegant Container

The container produced by this fork is my way of ensuring that the
site which builds today will also build tomorrow. It locks into place
a known-working version of the Pelican tool, plus various plugins and
supporting packages and my forked copy of the theme. It can be run
directly, or utilized via an action to produce a site build.

The container is multi-stage, first focusing on setting up a node
environment to perform the CSS and JS transformations. These results
are then copied into the final container which doesn't need node
installed in order to operate.


## Pelican Inelegant GitHub Action

The action produced by this fork provides an easy interface for
invoking the container to rebuild a site for deployment to GitHub
pages

```yaml
jobs:
  build-and-deploy:

    permissions:
      pages: write
      id-token: write

    environment:
      name: github-pages
      url: ${{ steps.deploy.outputs.page_url }}

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Build site
        id: pelican-build
        uses: obriencj/pelican-inelegant@master

      - name: Store site
        uses: actions/upload-pages-artifact@v3
        with:
          path: ${{ steps.pelican-build.outputs.output-path }}

      - name: Deploy site
        id: deploy
        uses: actions/deploy-pages@v4
```

The github action can be used with any theme, not just Inelegant.
However the theme will need to be available in your workflow checkout.
The theme path can be specified in the `pelicanconf.py` or via the
`theme` parameter to the action itself.


## Changes from Elegant

I liked a lot of what Elegant had to offer, but there were a few
things that didn't quite fit with my existing site content as I was
porting from Octopress to Pelican. So of course I had to get in
there and change some stuff! Inelegant is my messy attempt to
turn Elegant into what I needed.


### Overall Git Layout

I dropped the original documentation blog, and a number of dependency
files.

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

I removed redundant boundary lines, in particular between the last
entry in a listing (projects, recent articles) and the footer.

I also tweaked the footer to have a similar gradient to the heading,
to center the site title.

For articles and pages, I added a line-break between the title and
subtitle. For pages I added a sidebar to display publication and
modified dates just like for articles.


### Pages

I added a Pages header for listing all of the static non-article
pages. I had a lot of them, and the only other option was including
every single one in the navigation bar.


### Code blocks

I disliked the pygments theme that elegant went with, so I swapped
back to the pygments default theme. I also didn't particularly like the
Copy feature, so I ripped that out.


### Additional social links

I migrated the social SVG sources into CSS rather than being embedded
in every single page with a sidebar. I added [Discord], [Strava],
[Bluesky], [Threads], and [TikTok] support. I also updated the
[Keybase] image which looked really weird, and added [X] as rebranded
alternative for [Twitter].

[discord]: https://discord.com

[strava]: https://strava.com

[bluesky]: https://bsky.app

[threads]: https://threads.net

[tiktok]: https://tiktok.com

[keybase]: https://keybase.io

[x]: https://x.com

[twitter]: https://twitter.com


## License

Elegant is released under the [MIT License]. See their
[`THANKS.md`][thanks] file for a list of contributors.

Inelegant is released under the [MIT License] as was Elegant before it.

All code contributions are made directly under the [MIT License] as
well. This is commonly referred to as the "Inbound=Outbound licensing
model", as the license everyone contributes their code under
(i.e. inbound license) is exactly the same as the license that the
code is then being released under to the general public.

[thanks]: https://github.com/Pelican-Elegant/elegant/blob/master/THANKS.md
[mit license]: https://spdx.org/licenses/MIT.html
