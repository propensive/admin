TITLE=$(cat doc/title)

headers:

docs: readme.md .header

readme.md:
	envsubst .admin/readme.template > readme.md

contributing.md:
	envsubst .admin/contributing.template > contributing.md

.header:
	envsubst .admin/header.template > .header

.PHONY: headers docs compile