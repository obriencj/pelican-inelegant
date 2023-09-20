

dependencies:
	@yarn

gulp: dependencies
	@npx gulp

container: gulp
	@podman build . --no-cache -f Containerfile \
	  --tag 'pelican-inelegant:latest'


.PHONY: dependencies gulp container


# The end.
