
.EXPORT_ALL_VARIABLES:
LAUNCHER = Qmf4fcS6XzTq4zHwqgKDy5TbN94kMdXch9uA5qhTpnQzKY
TITLE = $(shell cat doc/title)
ID = $(shell cat doc/id)
START = $(shell cat doc/start)
STATUS = $(shell cat doc/status)
BASICS = $(shell cat doc/basics | tr '\n' '¶')
FEATURES = $(shell cat doc/features | tr '\n' '¶')
INTRO = $(shell cat doc/intro)
YEAR = $(shell date "+%y")
THANKS = $(shell cat doc/thanks 2> /dev/null || echo '')
VERSION = $(shell git describe --tags --abbrev=0 2> /dev/null)
TMP = .tmp.scala

SCALA = "2.12"

headers: .header
	@for file in $(shell find src -name '*.scala') ; do \
	  cat .header > $(TMP) ; \
	  sed '/\(package\|object\|import\)/,$$!d' "$$file" >> "$(TMP)" ; \
	  mv "$(TMP)" "$$file" ; \
	done && rm .header

docs: clean readme.md license.md contributing.md fury Makefile .gitignore .github/workflows/main.yml contributing.md

clean:
	rm -f readme.md license.md contributing.md fury .gitignore .github/workflows/main.yml

.github/workflows/main.yml:
	cp .admin/tmpl/github.yml .github/workflows/main.yml
fury:
	ipfs cat $(LAUNCHER) > fury
	chmod +x fury

doc/images/furore.png:
	mkdir -p doc/images
	cp .admin/images/furore.png doc/images/

doc/images/riotim.png:
	mkdir -p doc/images
	cp .admin/images/riotim.png doc/images/

doc/images/mavencentral.png:
	mkdir -p doc/images
	cp .admin/images/mavencentral.png doc/images/

readme.md: doc/images doc/images/furore.png doc/images/riotim.png doc/images/mavencentral.png
	cat .admin/tmpl/readme.md | envsubst | tr '¶' '\n' > readme.md

contributing.md:
	cat .admin/tmpl/contributing.md | envsubst | tr '¶' '\n' > contributing.md

.gitignore:
	cp .admin/tmpl/.gitignore .gitignore

Makefile:
	echo "include .admin/Makefile" > Makefile

license.md:
	cp .admin/tmpl/license.md license.md

contributors.md:
	git shortlog -sn > contributors.md

publish: pub/propensive
	

pub/propensive:
	rm -f .dependencies
	for mod in $(shell fury module list --project $(ID) --raw | sed 's/\x1b\[[0-9;]*m//g'); do \
	  export ARTIFACT="$(ID)-$${mod}_$(SCALA)" ; \
	  export F="$${ARTIFACT}-$(VERSION)" ; \
	  export D="pub/propensive/$$ARTIFACT/$(VERSION)" ; \
	  mkdir -p "$$D" ; \
	  for dep in $$(fury dependency list --raw --project $(ID) --module $${mod} | sed 's/\x1b\[[0-9;]*m//g' | sed 's/\//-/g'); do \
	    PDEP=$$(echo $${dep} | cut -d'-' -f1) ; \
	    export MOD_VER=$$(git ls-remote --tags --sort="v:refname" --refs git://github.com/propensive/$${PDEP} | tail -n1 | cut -d/ -f3 | sed 's/v//g') ; \
	    cat .admin/tmpl/.dependency | MOD="$(ID)-$${dep}_$(SCALA)" envsubst | tr '¶' '\n' >> .dependencies ; \
	  done ; \
	  fury build run --output linear --dir "$$D" --module $$mod --project $(ID) ; \
	  mv "$$D/$(ID)-$$mod.jar" "$$D/$$F.jar.tmp" ; \
	  find $$D -name '*.jar' | xargs rm ; \
	  mv "$$D/$$F.jar.tmp" "$$D/$$F.jar" ; \
	  cat .admin/tmpl/pom.xml | DEPS=$$(cat .dependencies) envsubst > $$D/$$F.pom ; \
	  gpg -ab $$D/$$F.pom ; \
	  gpg -ab $$D/$$F.jar ; \
	  echo $$(md5sum $$D/$$F.pom | head -c 32) > $$D/$$F.pom.md5 ; \
	  echo $$(md5sum $$D/$$F.pom.asc | head -c 32) > $$D/$$F.pom.asc.md5 ; \
	  echo $$(md5sum $$D/$$F.jar | head -c 32) > $$D/$$F.jar.md5 ; \
	  echo $$(md5sum $$D/$$F.jar.asc | head -c 32) > $$D/$$F.jar.asc.md5 ; \
	  echo $$(sha1sum $$D/$$F.pom | head -c 40) > $$D/$$F.pom.sha1 ; \
	  echo $$(sha1sum $$D/$$F.pom.asc | head -c 40) > $$D/$$F.pom.asc.sha1 ; \
	  echo $$(sha1sum $$D/$$F.jar | head -c 40) > $$D/$$F.jar.sha1 ; \
	  echo $$(sha1sum $$D/$$F.jar.asc | head -c 40) > $$D/$$F.jar.asc.sha1 ; \
	  rm -f .dependencies ; \
	done
	gsutil cp -r pub/* dir gs://repo.furore.dev/

.header:
	cat .admin/tmpl/.header | envsubst > .header

doc/images: doc/logo.svg
	@printf "Generating images for $$image..." ; \
	mkdir -p doc/images ; \
	inkscape doc/logo.svg --export-png=doc/images/2400x2400@300dpi.png --export-dpi='300,300' --export-width=2400 --export-height=2400 --export-background-opacity=0 > /dev/null ; \
	printf "." ; \
	inkscape doc/logo.svg --export-png=doc/images/1000x1000.png --export-dpi='96,96' --export-width=1000 --export-height=1000 --export-background-opacity=0 > /dev/null ; \
	printf "." ; \
	convert doc/images/1000x1000.png -resize 200x200 doc/images/200x200.png > /dev/null ; \
	printf "." ; \
	convert doc/images/1000x1000.png -resize 128x128 doc/images/128x128.png > /dev/null ; \
	printf "." ; \
	convert doc/images/1000x1000.png -resize 48x48 doc/images/48x48.png > /dev/null ; \
	printf "." ; \
	convert doc/images/1000x1000.png -resize 16x16 doc/images/16x16.png > /dev/null ; \
	printf "." ; \
	convert doc/images/1000x1000.png -background none -gravity center -resize 620x620 -extent 1280x640 doc/images/github.png > /dev/null ; \
	printf "." ; \
	convert doc/images/github.png .admin/images/github.png -background white -layers flatten doc/images/github.png > /dev/null ; \
	printf "." ; \
	printf "done\n" ; \

.PHONY: headers docs compile readme.md contributing.md .header doc/images publish
