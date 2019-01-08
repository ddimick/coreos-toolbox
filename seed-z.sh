#!/usr/bin/env sh
echo -e $(find ~/docker-stack -maxdepth 2 -type d -exec echo "{}|1|$(date +%s)\n" \;) > ~/docker-stack/build/coreos-toolbox/files/home/.z && sed -i "s/^\s//" ~/docker-stack/build/coreos-toolbox/files/home/.z
