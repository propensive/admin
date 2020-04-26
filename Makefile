
.EXPORT_ALL_VARIABLES:
LAUNCHER = Qmf4fcS6XzTq4zHwqgKDy5TbN94kMdXch9uA5qhTpnQzKY
TITLE = $(shell cat doc/title)
ID = $(shell cat doc/id)
START = $(shell cat doc/start)
BASICS = $(shell cat doc/basics | tr '\n' '¶')
FEATURES = $(shell cat doc/features | tr '\n' '¶')
INTRO = $(shell cat doc/intro)
YEAR = $(shell date "+%y")
THANKS = $(shell cat doc/thanks 2> /dev/null || echo '')
VERSION = $(shell git describe --tags 2> /dev/null)
TMP = .tmp.scala

headers: .header
	@for file in $(shell find src -name '*.scala') ; do \
	  cat .header > $(TMP) ; \
	  sed '/\(package\|object\|import\)/,$$!d' "$$file" >> "$(TMP)" ; \
	  mv "$(TMP)" "$$file" ; \
	done && rm .header

docs: clean readme.md license.md contributing.md fury Makefile .gitignore

clean:
	rm readme.md license.md contributing.md fury Makefile .gitignore

fury:
	ipfs cat $(LAUNCHER) > fury

doc/images/furore.png:
	cp .admin/images/furore.png doc/images/

doc/images/riotim.png:
	cp .admin/images/riotim.png doc/images/

doc/images/mavencentral.png:
	cp .admin/images/mavencentral.png doc/images/

readme.md: doc/images/furore.png doc/images/riotim.png doc/images/mavencentral.png
	cat .admin/tmpl/readme.md | envsubst | tr '¶' '\n' > readme.md

.gitignore:
	cp .admin/tmpl/.gitignore .gitignore

Makefile:
	echo "include .admin/Makefile" > Makefile

license.md:
	cp .admin/tmpl/license.md license.md

contributing.md:
	cat .admin/tmpl/contributing.md | envsubst > contributing.md

contributors.md:
	git shortlog -sn > contributors.md

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

.PHONY: headers docs compile readme.md contributing.md .header doc/images
