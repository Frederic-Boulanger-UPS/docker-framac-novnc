# Has to be authorized using:
# Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
$REPO="fredblgr/"
$NAME="framac-novnc"
$TAG="2021"
$RESOL="1440x900"
docker run --rm --detach --publish 6080:80 --volume "$(PWD):/workspace:rw" --env "RESOLUTION=${RESOL}" --name "${NAME}-run" "${REPO}${NAME}:${TAG}"
Start-Sleep -s 5
Start http://localhost:6080
