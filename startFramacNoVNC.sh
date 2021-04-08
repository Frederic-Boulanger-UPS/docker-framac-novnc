#!/bin/sh
REPO=fredblgr/
NAME=framac-novnc
ARCH=`uname -m`
TAG=2021
URL=http://localhost:6080

if [[ -z $SUDO_UID ]]
then
  # not in sudo
  USER_ID=`id -u`
  USER_NAME=`id -n -u`
else
  # in a sudo script
  USER_ID=${SUDO_UID}
  USER_NAME=${SUDO_USER}
fi

# You may add --env USER=<login> --env PASSWORD=<password> to run as a regular user (default is root)
docker run --rm --detach \
      --publish 6080:80 \
      --volume ${PWD}:/workspace:rw \
      --env USERNAME=${USER_NAME} --env USERID=${USER_ID} \
      --env RESOLUTION=1400x900 \
      --name ${NAME} \
      ${REPO}${NAME}:${TAG}

sleep 5

if [[ -z $SUDO_UID ]]
then
     su ${USER_NAME} -c 'open -a firefox http://localhost:6080' \
  || su ${USER_NAME} -c 'xdg-open http://localhost:6080' \
  || echo "Point your web browser at http://localhost:6080"
else
     open -a firefox http://localhost:6080 \
  || xdg-open http://localhost:6080 \
  || echo "Point your web browser at http://localhost:6080"
fi

# if command -v open 2>&1 /dev/null
# then
#   open ${URL}
# elif command -v xdg-open 2>&1 /dev/null
# then
#   xdg-open "${URL}"
# else
#   echo "# Point your browser at ${URL}"
#   echo "You may install xdg-utils so that I can do that for you."
# fi
