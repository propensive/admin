
.EXPORT_ALL_VARIABLES:
TITLE = $(shell cat doc/title)
ID = $(shell cat doc/id)
START = $(shell cat doc/start)
BASICS = $(shell cat doc/basics | tr '\n' '¶')
FEATURES = $(shell cat doc/features | tr '\n' '¶')
INTRO = $(shell cat doc/intro)
YEAR = $(shell date "+%y")
THANKS = $(shell cat doc/thanks 2> /dev/null || echo '')
VERSION = $(shell git describe --tags 2> /dev/null)

headers: .header
	#YEAR="$(date +%y)"
	#VERSION="$(cat .version | head -n1)"
	#TMP=".tmp.scala"
	#HEADER=".header"

	#if [[ "$VERSION" == "" ]]; then
	#  echo 'Usage: revise <version'
	#  exit 1
	#fi

	#if [[ ! -f "$HEADER" ]]; then
	#  echo 'The file .header does not exist.'
	#  exit 1
	#fi

	#for FILE in $(find src -name '*.scala'); do
	#  sed 's/%VERSION%/'"$VERSION"'/g' "$HEADER" | sed 's/%YEAR%/'$YEAR'/g' > "$TMP"
	#  sed '/\(package\|object\|import\)/,$!d' "$FILE" >> "$TMP"
	#  mv "$TMP" "$FILE"
	#done

docs: readme.md .header

doc/images/furore.png:
	cp .admin/images/furore.png doc/images/

doc/images/riot.png:
	cp .admin/images/riot.png doc/images/

readme.md: doc/images/furore.png doc/images/riot.png
	cat .admin/tmpl/readme.md | envsubst | tr '¶' '\n' > readme.md

license.md:
	cp .admin/tmpl/license.md license.md

contributing.md:
	cat .admin/tmpl/contributing.md | envsubst > contributing.md

contributors.md:

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
