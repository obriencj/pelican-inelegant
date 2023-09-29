# InElegant – a modified Elegant theme for Pelican

[Elegant] is a theme for the static site generator [Pelican].

InElegant is also a theme for the static site generator Pelican.
InElegant is based on Elegant, with some tweaks and fixes for my own
use.

pelican-inelegant is a container which bundles up the Pelican
tool, a selection of plugins, and the InElegant theme.


## Pelican Container

The container produced by this fork is my way of ensuring that
the site which builds today will also build tomorrow. It locks
into place a known-working version of the Pelican tool, plus
various plugins and supporting packages and my forked copy of
the Elegant theme.


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


### Pages

I Added a Pages header for listing all of the static non-article
pages. I had a lot of them, and the only other option was including
every single one in the navigation bar.


### Basic CSS

There was some fighting over block types for anchors and images that I
found annoying. I also didn't like the floating underline being
produced as a transform/translate. So now images correctly clear and
can be wrapped around with the `float` attribute.

I also tweaked the footer to center the site title, and added a line
break between title and subtitle (since some of mine were way too long
when presented on a single line).

I injected a site content copyright declaration into the html meta header.


### Code blocks

I disliked the pygments theme that elegant went with, so I swapped
back to the pygments default theme. I also didn't particularly like the
Copy feature, so I ripped that out.


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
[elegant]: https://github.com/Pelican-Elegant/elegant
[pelican]: https://getpelican.com/
[mit license]: https://spdx.org/licenses/MIT.html
