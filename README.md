# InElegant – a modified Elegant theme for Pelican

[Elegant] is a theme for the static site generator [Pelican].

InElegant is also a theme for the static site generator Pelican.
InElegant is based on Elegant, with some tweaks and fixes for my own
use.


## Differences from Elegant

So of course I had to get in there and change some stuff.


### Git Layout
I dropped the documentation blog, and a number of dependency files. I
have no intention of re-hosting the original elegant site as part of
this fork.

I re-organized the js and css sources that were minified/squished
together to the final js and css so that only the results were
published.

I added a Makefile for setting up the relevant node deps, using gulp
to do the js/css steps, and for creating a local copy of the
container.


### Pages
Added a Pages header for listing all of the static non-article
pages. I had a lot of them, and the only other option was including
every single one in the navigation bar.


### Basic CSS
There was some fighting over block types for anchors and images that I
found annoying. I also didn't like the floating underline being
produced as a transform/translate. So now images correctly clear and
can be wrapped around with the `float` attribute.


### Code blocks
I absolutely hated the theme that elegant went with, so I swapped back
to the pygments default theme. I also didn't particularly like the
Copy feature, so I ripped that out.


### InElegant Pelican Container

This fork produces a containerized version of Pelican with this
theme installed, for use in generating my own site. Feel free to use
it if you like it, but be warned that I might tweak things for my own
use cases.


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
