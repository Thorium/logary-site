#!/bin/bash
mkdocs build
cp -r site/ ../logary.github.io/
(cd ../logary.github.io
 git add .
 git commit -m 'update docs'
 git push)
