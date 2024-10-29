.PHONY: image
image:
	docker build -t ghcr.io/kylrth/slides:latest .

.PHONY: static
static:
	mkdir -p static
	docker run --rm --network none \
		-v $(shell pwd)/slides:/slides:ro \
		-v $(shell pwd)/static:/static \
		ghcr.io/kylrth/slides:main /slides --static /static
	rsync -av --delete slides/predoc/ static/predoc/
	rsync -av assets/ static/
# TODO use --static-dirs=predoc when they fix it
# https://github.com/webpro/reveal-md/issues/498

.PHONY: live
live:
	docker run --rm -p 8000:8000 -p 35729:35729 \
		-v $(shell pwd)/slides:/slides:ro \
		ghcr.io/kylrth/slides:main || exit 0
