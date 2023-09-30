

##@ Basic Targets

default:	help


help:	## Display this help  (default)
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


##@ Setup Environment

dependencies:	## Install dependencies using yarn
	@yarn


##@ Build

gulp:	## Build static CSS and JS
	@npx gulp


container: gulp	## Build the pelican-inelegant:latest container
	@podman build . -f Containerfile \
	  --tag 'pelican-inelegant:latest'


.PHONY: container dependencies gulp help


# The end.
