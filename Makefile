.PHONY: build rebuild watch

build:
	cabal run $@

rebuild: tmpdir := $(shell mktemp -d)
rebuild:
	mv _site/.git $(tmpdir)/.git
	cabal run $@
	mv $(tmpdir)/.git _site/.git
	rmdir $(tmpdir)

watch:
	cabal run $@

push: rebuild
	git submodule update

	@echo -e '\nPushing _blog...\n'
	cd _site
	git add .
	git commit -m "Site update"
	git push

	@echo -e '\nLinking submodule...\n'
	cd ..
	git add _blog
	git commit -m "Site update"
	git push

	@echo -e '\nSite updated...\n'
