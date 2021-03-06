.PHONY: build rebuild watch

SITE_CMD = stack exec -- site

build:
	$(SITE_CMD) $@

rebuild: tmpdir := $(shell mktemp -d)
rebuild:
	mv _site/.git $(tmpdir)/.git
	$(SITE_CMD) $@
	mv $(tmpdir)/.git _site/.git
	rmdir $(tmpdir)

watch:
	$(SITE_CMD) $@ --host 0.0.0.0

push: rebuild
	git submodule update

	@echo -e '\nPushing _blog...\n'
	cd _site \
	&& git checkout master \
	&& git add . \
	&& git commit -m "Site update" \
	&& git push

	@echo -e '\nLinking submodule...\n'
	git add _site
	git commit -m "Site update"
	git push

	@echo -e '\nSite updated...\n'
