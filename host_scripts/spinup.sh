#!/bin/bash

# attempts graceful exit
die () {
    echo >&2 "$@"
    exit 1
}

cdir=0
pull=0
current_dir=$PWD

while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -p|--pull)
    pull=1
    shift # past argument
    ;;
    -f|--folder)
    cdir=1
    folder="$2"
    shift # past argument
    ;;
    *)
          # unknown option
    ;;
  esac
  shift # past argument or value
done

# if a repo_uri is provided, change to that directory
exit_code=0
if [ "$cdir" -eq "1" ]; then
  if ! cd $folder; then
    exit_code=1
  fi
fi

# docker login if needed 

# if there's a Docker compose file, use it
if [ "$exit_code" -eq "0" ]; then
    if [ -f "docker-compose.yml" ]; then
        if [ "$pull" -eq "1" ]; then
          docker-compose pull
        fi
        if docker-compose build; then
            docker-compose run --service-ports --rm app
        fi
    # otherwise, just spin a specified Docker development container with the
    # present working directory (pwd) mounted
    else
        # validate number of parameters
        ["$#" -ge "1" ] || die "Invalid argument(s). USAGE: "\
        "spinup.sh [-p|--pull] [-f|--folder /path/to/code]  [platform] "

        platform=$1
        shift

        docker run -it -v $(pwd):/app $platform sh # needs work for some different platforms
    fi
fi

exit $exit_code
