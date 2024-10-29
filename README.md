# slides

These slides are compiled with [reveal.js](https://revealjs.com/).

## build

This repo builds a Docker image from scratch containing reveal.js and [reveal-md](https://github.com/webpro/reveal-md), which you can use to build these slides or your own slides. The Makefile defines `image`, `static`, and `live` phony targets which respectively build the image, build the static site, and serve the site dynamically, reloading on changes.
