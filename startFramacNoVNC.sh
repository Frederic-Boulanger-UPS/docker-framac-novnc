#!/bin/sh
REPO=fredblgr/
NAME=framac-novnc
ARCH=`uname -m`
TAG=2021
URL=http://localhost:6080

# You may add --env USER=<login> --env PASSWORD=<password> to run as a regular user (default is root)
docker run --rm --detach \
		  --publish 6080:80 \
		  --volume ${PWD}:/workspace:rw \
		  --env RESOLUTION=1200x800 \
		  --name ${NAME} \
		  ${REPO}${NAME}:${TAG}
sleep 5

if command -v open 2>&1 /dev/null
then
  open ${URL}
elif command -v xdg-open 2>&1 /dev/null
then
  xdg-open "${URL}"
else
  echo "# Point your browser at ${URL}"
  echo "You may install xdg-utils so that I can do that for you."
fi
