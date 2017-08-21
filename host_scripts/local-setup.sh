#!/bin/bash

# attempts graceful exit
die () {
  echo >&2 "$@"
  exit 1
}

# install spinup command
if [ -f "/usr/local/bin/spinup" ]; then
  rm -rf /usr/local/bin/spinup
fi
echo -e "#!/usr/bin/env bash\n\n"\
"bash $(pwd)/spinup.sh \$@" >> /usr/local/bin/spinup
chmod +x /usr/local/bin/spinup
chown $USER /usr/local/bin/spinup

docker network create local-dev

source ~/.bash_profile
