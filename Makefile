
.EXPORT_ALL_VARIABLES:

TITLE = $(shell cat doc/title)
START = $(shell cat doc/start)
YEAR = $(shell date "+%y")
VERSION = $(shell git describe --tags 2> /dev/null)

headers: .header

docs: readme.md .header

readme.md:
	cat .admin/tmpl/readme.md | envsubst > readme.md

license.md:
	cp .admin/tmpl/license.md license.md

contributing.md:
	cat .admin/tmpl/contributing.md | envsubst > contributing.md

contributors.md:

.header:
	cat .admin/tmpl/.header | envsubst > .header

.PHONY: headers docs compile
