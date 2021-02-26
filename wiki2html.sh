#!/bin/bash

echo "running"

hugo --themesDir ~/code/vattuonet/themes/ -t sk1 \
    --config ~/code/vattuonet/config.toml \
    --contentDir ~/Dropbox/vimwiki/vattuonet \
    -d ~/code/vattuonet/public  > /dev/null
