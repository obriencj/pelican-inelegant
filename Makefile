

dependencies:
	@yarn

gulp: dependencies
	@npx gulp

container: gulp
	@podman build . -f Containerfile \
	  --tag 'pelican-inelegant:latest'


.PHONY: dependencies gulp container


# The end.
