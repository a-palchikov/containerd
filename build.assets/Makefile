.PHONY: all

BUILDDIR := ../bin

all: | $(BUILDDIR)
	docker buildx build \
		--platform=local \
		--output=type=local,dest=$(BUILDDIR) \
		--target=releaser \
		--file ../Dockerfile \
		..

$(BUILDDIR):
	mkdir -p $@
