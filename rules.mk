clean: clean-builder
clean-builder:
	-( [ -f .dockerbuilder ] && rm -rf .dockerbuilder || true )

check-latest: check-builder
check-builder:
	$(DOCKER) $(DOCKER_OPTS) images | grep $(NAME)-builder | grep latest &>/dev/null || ( [ -f .dockerbuilder ] && rm -rf .dockerbuilder || true )

tag-builder:
	$(DOCKER) $(DOCKER_OPTS) tag -f $(NAME)-builder:$(TAG) $(NAME)-builder:latest

untag-builder:
	$(DOCKER) rmi -f $(NAME)-builder:$(TAG) $(NAME)-builder:latest

.dockerbuild: target/pandoc-citeproc

target/pandoc: .dockerbuilder
	@if test -f $@; then \
		touch $@; \
	else \
		$(DOCKER) $(DOCKER_OPTS) run --rm -v $(CURDIR)/target:/source $(NAME)-builder:$(TAG) cp -a /root/.cabal/bin/{pandoc,pandoc-citeproc} /source/ ; \
		 ( [ -f .dockerbuild ] && rm -rf .dockerbuild || true ) ; \
	fi

target/pandoc-citeproc: target/pandoc
## Recover from the removal of $@
	@if test -f $@; then :; else \
		rm -f target/pandoc; \
		$(MAKE) $(MAKEFLAGS) target/pandoc; \
	fi

.dockerbuilder:
	$(DOCKER) $(DOCKER_OPTS) build --force-rm -t $(NAME)-builder:$(TAG) -f Dockerfile.build .
	$(DOCKER) $(DOCKER_OPTS) tag -f $(NAME)-builder:$(TAG) $(NAME)-builder:latest
	touch $@;

untag-all: untag untag-builder
clean-all: clean clean-builder

.PHONY += clean-builder check-builder
