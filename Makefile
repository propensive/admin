TITLE=$(cat doc/title)

headers:

docs: readme.md .header

readme.md:
	cat .admin/readme.template | envsubst > readme.md

contributing.md:
	cat .admin/contributing.template | envsubst > contributing.md

.header:
	cat .admin/header.template | envsubst > .header

.PHONY: headers docs compile
